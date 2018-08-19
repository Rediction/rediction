# == Schema Information
#
# Table name: word_random_fetched_records # ランダムで取得した言葉のレコードのIDが格納されるテーブル
#
#  id         :bigint(8)        not null, primary key
#  token_id   :bigint(8)        not null              # トークンID(FK)
#  word_id    :bigint(8)        not null              # 言葉ID(FK)
#  created_at :datetime         not null
#

require "rails_helper"

RSpec.describe Word::RandomFetchedRecord, type: :model do
  describe "Classメソッド" do
    describe "bulk_insert_by_words_and_token_id" do
      subject { Word::RandomFetchedRecord.bulk_insert_by_words_and_token_id(token_id: fetched_token.id, words: words) }
      let(:fetched_token) { create(:word_random_fetched_token) }

      context "レコードを正常に登録した場合" do
        let(:words) { create_list(:word, 10) }

        it "全レコードが登録されていること" do
          expect{ subject }.to change(Word::RandomFetchedRecord, :count).by(10)
        end
      end
    end
  end
end
