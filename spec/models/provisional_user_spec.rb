require "rails_helper"

RSpec.describe ProvisionalUser, type: :model do
  let(:verification_token) { provisional_user.verification_token }
  let(:provisional_user) { create(:provisional_user) }

  describe "Instanceメソッド" do
    describe "save_with_verification_token" do

      context "登録処理に成功した場合" do
        subject { provisional_user.save_with_verification_token }

        it "uniqueなトークンがあること" do
          expect(verification_token).to be_present
        end

        it "レコードが生成されること" do
          expect{ subject }.to change(ProvisionalUser, :count).by(1)
        end
      end

      context "登録処理に失敗する場合" do
        it "レコードが生成されないこと" do
          expect{ subject }.to change(ProvisionalUser, :count).by(0)
        end
      end
    end
  end

  describe "classメソッド" do
    let(:token) { SecureRandom.uuid }

    describe "generate_token" do
      context "トークンがuniqueである場合" do
        it "uniqueなトークンが生成されること" do
          expect(token).not_to eq(verification_token)
        end
      end
    end
  end
end
