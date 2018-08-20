require "rails_helper"

describe ProvisionalUsersController, type: :controller do
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

  describe "POST #create"  do
    let(:provisional_user_params) { attributes_for(:provisional_user) }

    context "@provisional_userが保存に成功した場合" do
      subject { post :create, params: { provisional_user: provisional_user_params } }

      it "レコードが生成されること", :aggregate_failures do
        expect{ subject }.to change(ProvisionalUser, :count).by(1)
        expect(response).to have_http_status 200
        expect(response).to render_template "provisional_users/create"
      end
    end

    context "@provisional_userの保存に失敗した場合" do
      subject{ post :create, params: { provisional_user: provisional_user_params.merge(email: email) } }
      let(:email) { "" }

      it "レコードが生成されず、newテンプレートにrenderすること", :aggregate_failures do
        expect{ subject }.to change(ProvisionalUser, :count).by(0)
        expect(flash[:error]).to eq "仮会員登録に失敗しました。"
        expect(response).to render_template :new
      end
    end
  end
end
