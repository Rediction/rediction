# == Schema Information
#
# Table name: user_remember_me_tokens # ユーザーのRemember Me機能に利用するトークン
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)        not null              # ユーザーID(FK)
#  token_digest :string(255)      not null              # 認証用トークン
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require "rails_helper"

RSpec.describe User::RememberMeToken, type: :model do
  include_context 'Changesテーブルを有する場合', User::RememberMeToken
  let(:remember_me_token) { create(:user_remember_me_token, token_digest: token_digest) }
  let(:token_digest) { User::RememberMeToken.generate_digest(remember_token) }
  let(:remember_token) { User::RememberMeToken.generate_token }

  describe "Instanceメソッド" do
    describe "#authenticated?" do
      subject { remember_me_token.authenticated?(remember_token_arg) }

      context "トークンが正しい場合" do
        let(:remember_token_arg) { remember_token }
        it { is_expected.to eq true }
      end

      context "トークンが不正な場合" do
        let(:remember_token_arg) { "hoge" }
        it { is_expected.to eq false }
      end
    end

    describe "#forget" do
      subject { remember_me_token.forget }
      before { remember_me_token }

      context "正常にトークンが削除された場合" do
        it "レコードが削除され、その履歴が残ること", :aggregate_failures do
          expect{ subject }.to change(User::RememberMeToken, :count).by(-1).and \
            change(User::RememberMeTokenChange, :count).by(1)
          expect(User::RememberMeTokenChange.last&.event).to eq("delete")
        end
      end
    end

    describe "#update_token" do
      context "正常にトークンを更新した場合" do
        subject { remember_me_token.update_token }
        before { remember_me_token }

        it "レコードが更新され、その履歴が残ること", :aggregate_failures do
          expect{ subject }.to change(User::RememberMeToken, :count).by(0).and \
            change(User::RememberMeTokenChange, :count).by(1)
          expect(User::RememberMeTokenChange.last&.event).to eq("update")
        end

        it "認証トークンが更新されること" do
          expect{ subject }.to change{ remember_me_token.authenticated?(remember_token) }.from(true).to(false)
        end
      end
    end
  end

  describe "Classメソッド" do
    describe ".remember" do
      subject { User::RememberMeToken.remember(user) }
      let(:user) { create(:user) }

      context "トークンがまだ未登録の場合" do
        it "トークンが登録され、履歴が残ること", :aggregate_failures do
          expect{ subject }.to change(User::RememberMeToken, :count).by(1).and \
            change(User::RememberMeTokenChange, :count).by(1)
          expect(User::RememberMeTokenChange.last&.event).to eq("create")
        end
      end

      context "トークンが登録済みの場合" do
        # トークンが登録されている場合にこのメソッドを利用できないように例外が発生
        before { create(:user_remember_me_token, user_id: user.id) }
        it { expect{ subject }.to raise_error(RuntimeError) }
      end
    end
  end
end
