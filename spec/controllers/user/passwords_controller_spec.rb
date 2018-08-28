require "rails_helper"

describe User::PasswordsController, type: :controller do
  include_context 'current_userとしてログイン後にアクセスする'

  describe "GET #edit" do
    subject { get :edit }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    subject { patch :update, params: { user: user_password_params } }
    let(:user_password_params) { {current_password: current_password, password: password, password_confirmation: password } }
    let(:current_password) { current_user.password }
    let(:password) { "12345678" }

    context "ユーザーが現在登録中のパスワードを間違えた場合" do
      let(:current_password) { "" }

      it "レコードが更新されず、editにrenderすること", :aggregate_failures  do
        expect{ subject }.to change(UserChange, :count).by(0)
        expect(flash[:error]).to eq "現在登録中のパスワードが間違っています。"
        expect(response).to render_template :edit
      end
    end

    context "正常に更新に成功した場合" do
      it "HTTP 302", :aggregate_failures do
        subject
        expect(response).to have_http_status 302
        expect(response).to redirect_to user_mypage_path
        expect(flash[:success]).to eq "パスワードを更新しました。"
      end

      it "eventがupdateのChangesテーブルのレコードが登録されていること", :aggregate_failures do
        expect{ subject }.to change(UserChange, :count).by(1)
        expect(UserChange.last.event).to eq "update"
        expect(UserChange.last.user_id).to eq current_user.id
      end
    end
  end
end
