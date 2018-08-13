require "rails_helper"

describe Admin::HomeController, type: :controller do
  describe "GET #index" do
    subject { get :index }

    context "未ログイン状態の場合" do
      before { subject }

      it "HTTP 200 OK", :aggregate_failure do
        expect(response).to have_http_status 200
        expect(response).to render_template :index
      end
    end

    context "ログイン済みの場合" do
      include_context 'current_admin_userとしてログイン後にアクセスする'
      before { subject }

      it "HTTP 302 Moved Temporarily", :aggregate_failure do
        expect(response).to have_http_status 302
        expect(response).to redirect_to admin_dashboard_path
      end
    end
  end
end
