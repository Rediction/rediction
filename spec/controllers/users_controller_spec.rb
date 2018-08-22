require "rails_helper"

describe UsersController, type: :controller do
  include_context 'current_userとしてログイン後にアクセスする'

  describe "#show" do
    subject { get :show, params: { id: user.id } }
    before { subject }

    context "current_userのIDと同じIDでアクセスした場合" do
      let(:user) { current_user }

      it "マイページにリダイレクトされること", :aggregate_failures do
        expect(response).to have_http_status 302
        expect(response).to redirect_to user_mypage_path
      end
    end

    context "他のユーザーのページにアクセスした場合" do
      let(:user) { create(:user) }

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end
end
