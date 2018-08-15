require "rails_helper"

describe Admin::User::Resignation::RequestsController, type: :controller do
  include_context "current_admin_userとしてログイン後にアクセスする"
  let(:user) { create(:user) }

  shared_context "user_idに該当するユーザーが退会済みの場合" do
    context do
      let(:user) { create(:user, resigned: :resigned) }

      it "404が発生すること" do
        expect{ subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "GET #index" do
    subject { get :index }
    before { subject }
    let(:pagination_per) { 20 }

    context "ページネーションの制限以下に退会手続きが登録されている場合" do
      before { pagination_per.times { create(:user_resignation_request, user: create(:user, resigned: :resigned)) } }

      it "登録されている退会手続き全てが取得されること", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index
      end

      it "ページネーション制限数分のみ退会手続きが取得されていること" do
        expect(assigns(:requests).size).to eq pagination_per
      end

      it "IDの順で取得されていること" do
        expect(assigns(:requests).first).to eq User::Resignation::Request.last
      end
    end

    context "ページネーションの制限以上に退会手続きが登録されている場合" do
      before do
        (pagination_per + 1).times { create(:user_resignation_request, user: create(:user, resigned: :resigned)) }
      end

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index
      end

      it "ページネーション制限数分のみ退会手続きが取得されていること" do
        expect(assigns(:requests).size).to eq pagination_per
      end

      it "IDの順で取得されていること" do
        expect(assigns(:requests).first).to eq User::Resignation::Request.last
      end
    end
  end

  describe "GET #new" do
    subject { get :new, params: params }
    let(:params) { { user_id: user_id } }
    let(:user_id) { user.id }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        subject
        expect(response).to have_http_status 200
        expect(response).to render_template :new
        expect(assigns(:request).class).to eq User::Resignation::Request
      end
    end

    include_context "user_idに該当するユーザーが退会済みの場合"
  end

  describe "POST #create" do
    subject { post :create, params: params }
    let(:params) { { user_resignation_request: { description: description }, user_id: user.id } }
    let(:description) { "description" }

    context "登録に成功した場合" do
      it "HTTP 302 Moved Temporarily", :aggregate_failures do
        subject
        expect(response).to have_http_status 302
        expect(flash[:success]).to eq "ユーザーを退会させました。"
        expect(response).to redirect_to admin_user_path(assigns(:user))
      end

      it "レコードが生成されること" do
        expect{ subject }.to change(UserChange, :count).by(1).and change(User::Resignation::Request, :count).by(1)
      end

      it "ユーザーの退会状態がtrue(退会済み)になること" do
        expect{ subject }.to change{ user.reload.resigned? }.from(false).to(true)
      end

      it "ユーザーのchangesテーブルの退会状態がtrue(退会済み)で登録されていること" do
        expect{ subject }.to change{ UserChange.last&.resigned? }.from(nil).to(true)
      end
    end

    context "登録に失敗した場合" do
      # descriptionのValidation設定(文字数140文字以内に引っかかるようにしている)
      let(:description) { "あ" * 141 }

      it "HTTP 200 OK", :aggregate_failures do
        subject
        expect(response).to have_http_status 200
        expect(response).to render_template :new
        expect(flash[:error]).to eq "ユーザーの退会処理に失敗しました。"
      end

      it "レコードが生成されていないこと" do
        expect{ subject }.to change(UserChange, :count).by(0).and change(User::Resignation::Request, :count).by(0)
      end

      it "ユーザーの退会状態がfalseのままであること" do
        subject
        expect(user.unresigned?).to eq true
      end
    end

    include_context "user_idに該当するユーザーが退会済みの場合"
  end
end
