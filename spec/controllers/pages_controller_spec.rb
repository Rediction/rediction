require "rails_helper"

describe PagesController, type: :controller do
  include_context "current_userとしてログイン後にアクセスする"

  describe "GET #privacy_policy" do
    subject { get :privacy_policy }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :privacy_policy
      end
    end
  end

  describe "GET #terms_of_service" do
    subject { get :terms_of_service }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :terms_of_service
      end
    end
  end
end
