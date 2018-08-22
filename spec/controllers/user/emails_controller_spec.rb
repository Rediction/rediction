require "rails_helper"

describe User::EmailsController, type: :controller do
  include_context 'current_userとしてログイン後にアクセスする'

  describe "GET #edit" do
    subject { get :edit, params: { id: user.id } }
    before { subject }

    context "平常時アクセスの場合" do
      let(:user) { current_user }

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update", type: :doing do
    subject { patch :update, params: { user: user_email_params} }
    let(:user_email_params) { {email: current_user.email } }
    let(:email) { user.email }
    let(:user) { create(:user) }

    context "メールアドレスが変更前のものと同じ場合" do
      let(:email) { current_user.email }

      it "レコードが更新されず、editにrenderすること", :aggregate_failures  do
        expect{ subject }.to change(UserChange, :count).by(0)
        expect(flash[:error]).to eq "このメールアドレスは現在登録中のメールアドレスです。"
        expect(response).to render_template :edit
      end
    end

    context "メールアドレスが不正な場合" do
      let(:user_email_params) { {email: "" } }

      it "レコードが更新されず、editにrenderすること", :aggregate_failures  do
        expect{ subject }.to change(UserChange, :count).by(0)
        expect(flash[:error]).to eq "メールアドレスの更新に失敗しました。"
        expect(response).to render_template :edit
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
