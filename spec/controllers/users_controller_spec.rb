require "rails_helper"

describe UsersController, type: :controller do
  include_context 'current_userとしてログイン後にアクセスする'

  describe "#show" do
    subject { get :show, params: { id: user.id } }
    before { subject }

    context "current_userのIDと同じIDでアクセスした場合" do
      let(:user) { current_user }

      it "マイページにリダイレクトされること", :aggregate_failures do
        expect(response).to have_http_status 302
        expect(response).to redirect_to user_mypage_path
      end
    end

    context "他のユーザーのページにアクセスした場合" do
      let(:user) { create(:user) }

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end

  describe "GET #edit_email", type: :doing do
    subject { get :edit_email, params: { id: user.id } }
    before { subject }

    context "平常時アクセスの場合" do
      let(:user) { current_user }

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :edit_email
      end
    end
  end

  describe "PATCH #update_email", type: :doing do
    subject { patch :update_email, params: { user: user_email_params} }
    let(:user_email_params) { {email: current_user.email } }
    let(:email) { user.email }
    let(:user) { create(:user) }

    context "メールアドレスが変更前のものと同じ場合" do
      it "レコードが更新されず、edit_emailにrenderすること" do
        expect(user.email).to eq email
        expect{ subject }.to change(UserChange, :count).by(0)
        expect(flash[:error]).to eq "以前使用していたメールアドレスは使用できません。"
        expect(response).to render_template :edit_email
      end
    end

    context "正常に更新に成功した場合" do
      let(:user_email_params) { {email: "goo@gmail.com" } }

      it "HTTP 302", :aggregate_failures do
        subject
        expect(response).to have_http_status 302
        expect(response).to redirect_to user_mypage_path
        expect(flash[:success]).to eq "メールアドレスを更新しました。"
      end

      it "eventがupdateのChangesテーブルのレコードが登録されていること", :aggregate_failures do
        expect{ subject }.to change(UserChange, :count).by(1)
        expect(UserChange.last.event).to eq "update"
        expect(UserChange.last.user_id).to eq current_user.id
      end
    end
  end
end
