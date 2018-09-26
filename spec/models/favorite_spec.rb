# == Schema Information
#
# Table name: favorites # お気に入り
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null              # ユーザーID(FK)
#  word_id    :bigint(8)        not null              # 言葉ID(FK)
#  created_at :datetime         not null
#

require "rails_helper"

RSpec.describe Favorite, type: :model do
  include_context 'Changesテーブルを有する場合', Favorite

  describe "Classメソッド" do
    describe ".toggle_status!" do
      subject { Favorite.toggle_status!(word_id: word_id, user_id: user_id) }
      let(:user_id) { user.id }
      let(:word_id) { word.id }
      let(:user) { create(:user) }
      let(:word) { create(:word) }

      context "user_idとword_idに該当するレコードが登録されている場合" do
        let(:favorite) { create(:favorite, word_id: word_id, user_id: user_id) }
        before { favorite }

        it "レコードが削除されること" do
          expect{ subject }.to change(Favorite, :count).by(-1)
          expect(Favorite.exists?(id: favorite.id)).to eq false
        end

        it "nilが返されること" do
          is_expected.to eq nil
        end

        it "changesテーブルのeventがdeleteとして登録されること" do
          expect{ subject }.to change(FavoriteChange, :count).by(1)
          expect(FavoriteChange.last&.favorite_id).to eq favorite.id
          expect(FavoriteChange.last&.event).to eq "delete"
        end
      end

      context "user_idとword_idに該当するレコードが登録されていない場合" do
        it "レコードが登録されること" do
          expect{ subject }.to change(Favorite, :count).by(1)
        end

        it "生成されたレコードが返されること" do
          is_expected.to eq Favorite.last
        end

        it "changesテーブルのeventがcreateとして登録されること" do
          expect{ subject }.to change(FavoriteChange, :count).by(1)
          expect(FavoriteChange.last&.favorite_id).to eq Favorite.last.id
          expect(FavoriteChange.last&.event).to eq "create"
        end
      end
    end

    describe ".extract_favorite_word_ids" do
      subject { Favorite.extract_favorite_word_ids(words: words, user_id: user.id) }
      let(:user) { create(:user) }
      let(:words) { create_list(:word, 10) }

      context "wordsが空配列の場合" do
        let(:words) { [] }

        it "空配列が返されること" do
          is_expected.to eq []
        end
      end

      context "引数のwordsのうちuser_idに該当するユーザーのお気に入り中のものが存在しない場合" do
        it "空配列が返されること" do
          is_expected.to eq []
        end
      end

      context "引数のwordsのうち１つがuser_idに該当するユーザーのお気に入り中のものである場合" do
        before { create(:favorite, user_id: user.id, word_id: target_word.id) }
        let(:target_word) { words.first }

        it "お気に入り中のwordのIDのみが格納されていること" do
          is_expected.to eq [target_word.id]
        end
      end

      context "引数のwords全てがuser_idに該当するユーザーのお気に入り中のものである場合" do
        before { words.each { |word| create(:favorite, user_id: user.id, word_id: word.id) } }

        it "引数のwordsのID全てが格納されている配列が返されること" do
          is_expected.to eq words.map(&:id)
        end
      end
    end

    describe ".favorite_counts_hash" do
      subject { Favorite.favorite_counts_hash(words) }
      let(:words) { create_list(:word, 5) }
      let(:result) { subject }

      context "全てのwordのお気に入り件数が0件より多い場合" do
        before { words.each { |word| create(:favorite, word: word) } }

        it "全てのwordのお気に入り件数がハッシュ形式で返されること" do
          expect(result.size).to eq words.size
          expect(words.all? { |word| result[word.id] == 1 }).to eq true
        end
      end

      context "1つのwordのお気に入り件数のみ0件より多い場合" do
        before { create(:favorite, word: words.first) }

        it "お気に入り件数の多いwordのお気に入り件数のみがハッシュ形式で返されること" do
          expect(result.size).to eq 1
          expect(result[words.first.id]).to eq 1
        end
      end

      context "全てのwordのお気に入り件数が0件の場合" do
        it "空のハッシュが返されること" do
          expect(result.size).to eq 0
        end
      end
    end
  end
end
