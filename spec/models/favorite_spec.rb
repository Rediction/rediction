require "rails_helper"

RSpec.describe Favorite, type: :model do
  include_context 'Changesテーブルを有する場合', Favorite

  describe "Classメソッド"
    describe ".toggleStatus!" do
      subject { Favorite.toggleStatus(word_id: word_id, user_id: user_id) }
      let(:user_id) { user.id }
      let(:word_id) { word.id }
      let(:user) { create(:user) }
      let(:word) { create(:word) }

      context "user_idとword_idに該当するレコードが登録されている場合" do
        let(:favorite) { Favorite.create_with_changes!(word_id: word_id, user_id: user_id) }
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
          expect(FavoriteChange.last&.favorite_id).to eq Favorite.last
          expect(FavoriteChange.last&.event).to eq "create"
        end
      end
    end
  end
end
