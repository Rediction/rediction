require "rails_helper"

describe ProvisionalUsersController, type: :controller do
  let(:provisional_user_params) { attributes_for(:provisional_user) }

  describe "GET #new" do
    subject { get :new }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    context "@provisional_userが保存に成功した場合" do
      subject { post :create, params: { provisional_user: provisional_user_params } }

      it "レコードが生成されること", :aggregate_failures do
        expect{ subject }.to change(ProvisionalUser, :count).by(1)
        expect(response).to have_http_status 200
      end
    end

    context "@provisional_userの保存に失敗した場合" do
      subject{ post :create, params: { provisional_user: { email: email, password: password, verification_token: verification_token } } }
      let(:email) { provisional_user_params[:email] }
      let(:password) { provisional_user_params[:password] }
      let(:verification_token) { provisional_user_params[:verification_token] }
      let(:email) { "" }

      it "レコードが生成されず、newアクションにrenderすること", :aggregate_failures do
        expect{ subject }.to change(ProvisionalUser, :count).by(0)
        expect(flash[:error]).to eq "仮会員登録に失敗しました。"
        expect(response).to render_template :new
      end

    end
  end
end
