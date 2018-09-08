require 'rails_helper'

# SessionHelperはApplicationControllerにincludeされることを前提として作られているため、
# テストもinclude先のApplicationControllerを中心として行う。
RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    include SessionHelper
  end

  let(:user) { create(:user) }
  let(:cookies) { controller.send(:cookies) }
  let(:session) { controller.session }

  describe "#log_in" do
    subject { controller.log_in(user) }

    context "正常にログインした場合" do
      it "永続ログイン状態になり、ログイン成功記録が登録されること", :aggregate_failures do
        expect{ subject }.to change(User::RememberMeToken, :count).by(1).and \
          change(User::RememberMeTokenChange, :count).by(1).and \
          change(UserAuthLog, :count).by(1)
        expect(User::RememberMeTokenChange.last&.event).to eq("create")
        expect(UserAuthLog.last&.success).to eq true
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end

  describe "logged_in?" do
    subject { controller.logged_in? }

    context "ログイン状態の場合" do
      context "セッションにログイン情報が保存されている場合" do
        before { session.merge!({ user_id: user.id }) }
        it { is_expected.to eq true }
      end

      context "Cookieに永続ログイン情報が保存されている場合" do
        before do
          remember_token = User::RememberMeToken.remember(user)
          cookies.permanent.signed[:user_id] = user.id
          cookies.permanent[:remember_token] = remember_token
        end

        it { is_expected.to eq true }
      end
    end

    context "未ログイン状態の場合" do
      it { is_expected.to eq false }
    end
  end

  describe "log_out" do
    subject { controller.log_out }

    context "正常にログアウトした場合" do
      before { controller.log_in(user) }
      it "session, @current_userが初期化され、永続認証用トークンが削除されること", :aggregate_failures do
        expect{ subject }.to change{ session[:user_id] }.from(user.id).to(nil).and \
          change{ controller.current_user }.from(user).to(nil).and \
          change(User::RememberMeToken, :count).by(-1).and \
          change(User::RememberMeTokenChange, :count).by(1)
        expect(User::RememberMeTokenChange.last&.event).to eq("delete")
      end
    end
  end

  describe "current_user" do
    subject { controller.current_user }

    context "Sessionにuser_idが格納されている場合" do
      before { session.merge!({ user_id: user.id }) }

      it "user_idに該当するユーザーのインスタンスが返されること" do
        is_expected.to eq user
      end
    end

    context "Cookieに永続認証情報が格納されている場合" do
      before do
        remember_token = User::RememberMeToken.remember(user)
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = remember_token
      end

      it "user_idに該当するユーザーのインスタンスが返されること" do
        is_expected.to eq user
      end
    end

    context "Session, Cookieともに存在しない場合" do
      it { is_expected.to eq nil }
    end
  end

  describe "remember_user" do
    subject { controller.remember_user(user) }

    context "正常に保存できた場合" do
      it "トークンがDBに登録されていること", :aggregate_failures do
        expect{ subject }.to change(User::RememberMeToken, :count).by(1).and \
          change(User::RememberMeTokenChange, :count).by(1)
        expect(User::RememberMeTokenChange.last&.event).to eq("create")
      end

      it "永続認証用のCookieが保存されていること", :aggregate_failures do
        subject
        expect(cookies.signed[:user_id]).to eq(user.id)
        expect(cookies[:remember_token].present?).to eq true
        expect(cookies[:token_keeper].present?).to eq true
      end
    end
  end

  describe "update_remember_token" do
    subject { controller.update_remember_token }
    before do
      remember_me_token
      controller.log_in(user)
    end
    let(:remember_me_token) { create(:user_remember_me_token, user_id: user.id) }

    context "正常に保存できた場合" do
      it "トークンが更新され、履歴が登録されていること", :aggregate_failures do
        expect{ subject }.to change(User::RememberMeToken, :count).by(0).and \
          change(User::RememberMeTokenChange, :count).by(1)
        expect(User::RememberMeTokenChange.last&.event).to eq("update")
      end

      it "永続認証用のCookieが保存されていること", :aggregate_failures do
        subject
        expect(user.reload.remember_me_token.token_digest).not_to eq remember_me_token.token_digest
        expect(cookies[:remember_token].present?).to eq true
        expect(cookies[:token_keeper].present?).to eq true
      end
    end
  end

  describe "register_token_keeper" do
    subject { controller.register_token_keeper }
    before { subject }
    it "1が返されること" do
      expect(cookies[:token_keeper]).to eq 1
    end
  end

  describe "require_token_update?" do
    subject { controller.require_token_update? }
    before do
      remember_token = User::RememberMeToken.remember(user)
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = remember_token
      cookies[:token_keeper] = nil
    end

    context "トークンを更新する必要がある場合" do
      it { is_expected.to eq true }
    end

    context "トークンを更新する必要がない場合" do
      context "Cookieのtoken_keeperが存在する場合" do
        before { cookies.permanent[:token_keeper] = 1 }
        it { is_expected.to eq false }
      end

      context "Cookieのuser_idが存在しない場合" do
        before { cookies.permanent[:user_id] = nil }
        it { is_expected.to eq false }
      end

      context "Cookieのremember_tokenが存在しない場合" do
        before { cookies[:remember_token] = nil }
        it { is_expected.to eq false }
      end

      context "ログイン中でない場合" do
        it do
          allow(controller).to receive(:logged_in?).and_return(false)
          is_expected.to eq false
        end
      end
    end
  end

  describe "forget_user" do
    subject { controller.forget_user(user) }
    before do
      controller.remember_user(user)
      user.reload
    end

    context "正常に削除できた場合" do
      it "認証用トークンのレコードが削除され、履歴が残っていること", :aggregate_failures do
        expect{ subject }.to change(User::RememberMeToken, :count).by(-1).and \
          change(User::RememberMeTokenChange, :count).by(1)
        expect(User::RememberMeTokenChange.last&.event).to eq("delete")
      end

      it "認証用のCookieが削除されていること" do
        expect{ subject }.to change{ cookies[:user_id].present? }.from(true).to(false).and \
          change{ cookies[:remember_token].present? }.from(true).to(false).and \
          change{ cookies[:token_keeper].present? }.from(true).to(false)
      end
    end
  end
end
