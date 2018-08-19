# == Schema Information
#
# Table name: word_random_fetched_tokens # ランダムで取得した言葉に紐づくユニークなトークンが格納されるテーブル
#
#  id         :bigint(8)        not null, primary key
#  token      :string(255)      not null              # トークン
#  created_at :datetime         not null
#

require "rails_helper"

RSpec.describe Word::RandomFetchedToken, type: :model do
  describe "Classメソッド" do
    describe "first_or_create_unique_token" do
      subject { Word::RandomFetchedToken.first_or_create_unique_token(token) }
      let(:token) { nil }

      context "tokenがnilの場合" do
        it "新しいレコードが登録されること" do
          expect{ subject }.to change(Word::RandomFetchedToken, :count).by(1)
        end

        it "作成したレコードが返されること" do
          expect(subject).to eq Word::RandomFetchedToken.last
        end
      end

      context "tokenが登録されていない値の場合" do
        let(:token) { "HOGE" }

        it "新しいレコードが登録されること" do
          expect{ subject }.to change(Word::RandomFetchedToken, :count).by(1)
        end

        it "作成したレコードが返されること" do
          expect(subject).to eq Word::RandomFetchedToken.last
        end
      end

      context "tokenに作成済みのトークンが格納されている場合" do
        let(:token) { fetched_token.token }
        let(:fetched_token) { create(:word_random_fetched_token) }

        it "トークンの一致するレコードが返されること" do
          is_expected.to eq fetched_token
        end

        it "レコードが作成されないこと" do
          fetched_token
          expect{ subject }.to change(Word::RandomFetchedToken, :count).by(0)
        end
      end
    end
  end
end
