# == Schema Information
#
# Table name: provisional_users # 仮ユーザー情報
#
#  id                 :bigint(8)        not null, primary key
#  email              :string(255)      not null              # メールアドレス
#  password_digest    :string(255)      not null              # パスワード
#  verification_token :string(255)      not null              # 検証用トークン
#  created_at         :datetime         not null
#

require "rails_helper"

RSpec.describe ProvisionalUser, type: :model do
  let(:provisional_user) { attributes_for(:provisional_user) }

  describe "Instanceメソッド" do
    describe "#save_with_verification_token" do
      subject { provisional_user.save_with_verification_token }
      let(:provisional_user) { build(:provisional_user, verification_token: "") }
      let(:verification_token) { ProvisionalUser.generate_token }
      let(:token) { provisional_user[:verification_token] }

      context "登録処理に成功した場合" do
        it "uniqueなトークンがあること" do
          subject
          expect(verification_token).not_to eq token
        end

        it "レコードが生成されること" do
          expect{ subject }.to change(ProvisionalUser, :count).by(1)
        end
      end

      context "登録処理に失敗する場合" do
      let(:provisional_user) { build(:provisional_user, email: "") }
        it "レコードが生成されないこと" do
          expect{ subject }.to change(ProvisionalUser, :count).by(0)
        end
      end
    end
  end

  describe "classメソッド" do
    describe "generate_token" do
      subject{ ProvisionalUser.generate_token }
      let(:token) { provisional_user[:verification_token] }

      context "トークンがuniqueである場合" do
        it "uniqueなトークンが生成されること" do
          expect(subject).not_to eq token
        end
      end
    end
  end
end
