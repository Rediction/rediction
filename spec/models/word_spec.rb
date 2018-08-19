# == Schema Information
#
# Table name: words # 言葉
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  name        :string(255)      not null              # 名前
#  phonetic    :string(255)      not null              # ふりがな
#  description :string(255)      not null              # 説明
#  created_at  :datetime         not null
#

require "rails_helper"

RSpec.describe Word, type: :model do
  include_context 'Changesテーブルを有する場合', Word

  describe "Classメソッド" do
    describe "find_random_by_fetched_token" do
      subject { Word.find_random_by_fetched_token(token: token, limit: limit) }
      let(:token) { "xxxxxxxxxxxxx" }
      let(:limit) { 10 }

      context "トークンが空の場合" do
        before { create_list(:word, limit) }

        it "登録されてる値が全て取得できること" do
          expect(subject.size).to eq limit
        end
      end

      context "トークンにWordが紐づいている場合" do
        before do
          create_list(:word, limit)
          create(:word_random_fetched_record, word: Word.last, token: fetched_token)
        end
        let(:fetched_token) { create(:word_random_fetched_token) }
        let(:token) { fetched_token.token }

        it "トークンに紐づいているWordが取得されないこと", :aggregation_failures do
          expect(subject.size).to eq limit - 1
          expect(subject.map(&:id)).not_to include Word.last.id
        end
      end
    end

    describe "find_latest_records" do
      subject { Word.find_latest_records(limit: limit, max_fetched_id: max_fetched_id) }
      let(:max_fetched_id) { nil }
      let(:limit) { 10 }

      context "正常時の場合" do
        before { create_list(:word, limit) }

        it "ID降順でレコードが取得されること" do
          ids = subject.map(&:id)
          expect(ids).to eq(ids.sort { |a, b| b <=> a })
        end
      end

      context "limitより多くレコードが登録されている場合" do
        before { create_list(:word, limit + 1) }

        it "limit数分のみ取得できること" do
          expect(subject.size).to eq limit
        end
      end

      context "max_fetched_idが指定されている場合" do
        before { create_list(:word, limit + 1) }
        let(:max_fetched_id) { Word.last }

        it "max_fetched_idより前のIDのみが取得されること" do
          expect(subject.map(&:id)).not_to include max_fetched_id
        end
      end
    end
  end
end
