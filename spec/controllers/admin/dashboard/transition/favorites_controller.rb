require "rails_helper"

describe Admin::Dashboard::Transition::FavoritesController, type: :controller do
  include_context 'current_admin_userとしてログイン後にアクセスする'

  describe "GET #favorite" do
    subject { get :favorite }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end
end
