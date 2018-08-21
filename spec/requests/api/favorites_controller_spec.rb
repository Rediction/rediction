require "rails_helper"

describe Api::FavoritesController, type: :request do
  include_context "APIを認証済み状態にする"

   describe "PATCH #update" do
    subject { patch api_word_user_favorite_path(word_id: word_id, user_id: user_id) }
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

      it "is_favoriteにfalseが格納されて返されること" do
        subject
        expect(JSON.parse(response.body)["favorite_id"]).to eq nil
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

      it "is_favoriteにtrueが格納されて返されること" do
        subject
        expect(JSON.parse(response.body)["favorite_id"]).to eq Favorite.last.id
      end

      it "changesテーブルのeventがcreateとして登録されること" do
        expect{ subject }.to change(FavoriteChange, :count).by(1)
        expect(FavoriteChange.last&.favorite_id).to eq Favorite.last.id
        expect(FavoriteChange.last&.event).to eq "create"
      end
    end
   end
end
