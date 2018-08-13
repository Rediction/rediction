require "rails_helper"

describe Admin::DashboardsController, type: :controller do
  include_context 'current_admin_userとしてログイン後にアクセスする'

  describe "GET #show" do
    subject { get :show }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failure do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end
end
