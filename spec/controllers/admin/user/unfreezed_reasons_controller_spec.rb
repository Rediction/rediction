require "rails_helper"

describe Admin::User::UnfreezedReasonsController, type: :controller do
  include_context "current_admin_userとしてログイン後にアクセスする"
  let(:user) { create(:user, freezed: :freezed) }

  shared_context "user_idに該当するユーザーが凍結中の場合" do
    context do
      let(:user) { create(:user) }

      it "404が発生すること" do
        expect{ subject }.to raise_error ActiveRecord::RecordNotFound
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
        expect(assigns(:unfreezed_reason).class).to eq User::UnfreezedReason
      end
    end

    include_context "user_idに該当するユーザーが凍結中の場合"
  end

  describe "POST #create" do
    subject { post :create, params: params }
    let(:params) { { user_unfreezed_reason: { description: description }, user_id: user.id } }
    let(:description) { "description" }

    context "登録に成功した場合" do
      it "HTTP 302 Moved Temporarily", :aggregate_failures do
        subject
        expect(response).to have_http_status 302
        expect(flash[:success]).to eq "ユーザーの凍結を解除しました。"
        expect(response).to redirect_to admin_user_path(assigns(:user))
      end

      it "レコードが生成されること" do
        expect{ subject }.to change(UserChange, :count).by(1).and change(User::UnfreezedReason, :count).by(1)
      end

      it "ユーザーの凍結状態がfalse(未凍結)になること" do
        expect{ subject }.to change{ user.reload.unfreezed? }.from(false).to(true)
      end

      it "ユーザーのchangesテーブルの凍結状態がfalse(未凍結)で登録されていること" do
        expect{ subject }.to change{ UserChange.last&.unfreezed? }.from(nil).to(true)
      end
    end

    context "登録に失敗した場合" do
      # descriptionのValidation設定(文字数140文字以内に引っかかるようにしている)
      let(:description) { "あ" * 141 }

      it "HTTP 200 OK", :aggregate_failures do
        subject
        expect(response).to have_http_status 200
        expect(response).to render_template :new
        expect(flash[:error]).to eq "ユーザーの凍結の解除に失敗しました。"
      end

      it "レコードが生成されていないこと" do
        expect{ subject }.to change(UserChange, :count).by(0).and change(User::UnfreezedReason, :count).by(0)
      end

      it "ユーザーの凍結状態がtrueのままであること" do
        subject
        expect(user.freezed?).to eq true
      end
    end

    include_context "user_idに該当するユーザーが凍結中の場合"
  end
end
