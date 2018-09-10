require "rails_helper"

describe Admin::Dashboard::Ranking::UsersController, type: :controller do
  include_context 'current_admin_userとしてログイン後にアクセスする'

  describe "GET #favorited_words" do
    subject { get :favorited_words }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end

  describe "GET #favoriting_words" do
    subject { get :favoriting_words }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end

  describe "GET #posted_words" do
    subject { get :posted_words }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end

  describe "GET #followed" do
    subject { get :followed }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end

  describe "GET #following" do
    subject { get :following }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end
end
