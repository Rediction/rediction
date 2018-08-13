require "rails_helper"

describe Admin::WordsController, type: :controller do
  include_context 'current_admin_userとしてログイン後にアクセスする'

  describe "GET #index" do
    subject { get :index }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failure do
        expect(response).to have_http_status 200
        expect(response).to render_template :index
      end
    end
  end
end
