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
  end
end
