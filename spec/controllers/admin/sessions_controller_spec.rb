require "rails_helper"

describe Admin::SessionsController, type: :controller do
  describe "GET #create" do
    subject { get :create }

    context "管理者ユーザーとして登録済みのGmailでOAuthログインした場合" do
      before do
        create(:admin_user, email: "example@gmail.com")
        subject
      end

      it "HTTP 302 Moved Temporarily", :aggregate_failures do
        expect(response).to have_http_status 302
        expect(response).to redirect_to admin_dashboard_path
        expect(flash[:success]).to eq "管理画面にログインしました。"
        expect(controller.send(:current_admin_user)).to eq Admin::User.first
      end
    end

    context "管理者ユーザーとして登録されてないGmailでOAuthログインした場合" do
      before do
        create(:admin_user, email: "hoge@gmail.com")
        subject
      end

      it "HTTP 302 Moved Temporarily", :aggregate_failures do
        expect(response).to have_http_status 302
        expect(response).to redirect_to admin_root_path
        expect(flash[:error]).to eq "認証に失敗しました。"
      end
    end
  end

  describe "GET #destroy" do
    include_context "current_admin_userとしてログイン後にアクセスする"
    subject { get :destroy }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 302 Moved Temporarily", :aggregate_failures do
        expect(response).to have_http_status 302
        expect(response).to redirect_to admin_root_path
        expect(flash[:success]).to eq "ログアウトしました。"
      end
    end
  end
end
