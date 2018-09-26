require "rails_helper"

describe SessionsController, type: :controller do
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
    subject { post :create, params: { user_login_form: login_form_params } }
    let(:login_form_params) { { email: email, password: password } }
    let(:email) { user.email }
    let(:password) {user.password }
    let(:user) { create(:user) }

    context "メールアドレスとパスワードが正しい場合" do
      it "正常にログイン処理が行われること", :aggregate_failures do
        expect{ subject }.to change{ session[:user_id] }.from(nil).to(user.id).and \
          change(User::RememberMeToken, :count).by(1).and \
          change(User::RememberMeTokenChange, :count).by(1).and \
          change(UserAuthLog, :count).by(1)
        expect(User::RememberMeTokenChange.last&.event).to eq("create")
        expect(UserAuthLog.last&.success).to eq true
      end

      it "永続認証用のCookieが保存されていること", :aggregate_failures do
        subject
        expect(cookies.signed[:user_id]).to eq(user.id)
        expect(cookies[:remember_token].present?).to eq true
        expect(cookies[:token_keeper]).to eq 1
      end

      it "HTTP 302 Moved Temporarily", :aggregate_failures do
        subject
        expect(response).to have_http_status 302
        expect(response).to redirect_to index_latest_order_words_path
        expect(flash[:success]).to eq "ログインしました。"
      end
    end

    context "メールアドレスが違う場合" do
      let(:email) { "example@gmail.com" }

      it "ログインに失敗すること", :aggregate_failures do
        expect{ subject }.to change(User::RememberMeToken, :count).by(0).and \
          change(User::RememberMeTokenChange, :count).by(0).and \
          change(UserAuthLog, :count).by(0)
        expect(flash[:error]).to eq "メールアドレスまたはパスワードが正しくありません。"
        expect(response).to render_template :new
      end
    end

    context "パスワードが違う場合" do
      let(:password) { "12345678" }

      it "ログインに失敗すること", :aggregate_failures do
        expect{ subject }.to change(User::RememberMeToken, :count).by(0).and \
          change(User::RememberMeTokenChange, :count).by(0).and \
          change(UserAuthLog, :count).by(1)
        expect(UserAuthLog.last&.success).to eq false
        expect(flash[:error]).to eq "メールアドレスまたはパスワードが正しくありません。"
        expect(response).to render_template :new
      end
    end

    context "メールアドレス & パスワードの両方を間違えた場合" do
      let(:email) { "example@gmail.com" }
      let(:password) { "12345678" }

      it "ログインに失敗すること", :aggregate_failures do
        expect{ subject }.to change(User::RememberMeToken, :count).by(0).and \
          change(User::RememberMeTokenChange, :count).by(0).and \
          change(UserAuthLog, :count).by(0)
        expect(flash[:error]).to eq "メールアドレスまたはパスワードが正しくありません。"
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE #destroy" do
    before { controller.log_in(user) }
    subject { delete :destroy }
    let(:user) { create(:user_with_profile) }

    context "平常時アクセスの場合" do
      # TODO(shuji ota):ユーザーがログアウトする際にcookiesが削除されるように改修されたらそのテストを追加する
      it "Cookieが削除されること"

      it "HTTP 302 Moved Temporarily", :aggregate_failures do
        expect{ subject }.to change{ session[:user_id] }.from(session[:user_id]).to(nil)
        expect(response).to have_http_status 302
        expect(response).to redirect_to new_login_path
        expect(flash[:success]).to eq "ログアウトしました。"
      end
    end
  end
end
