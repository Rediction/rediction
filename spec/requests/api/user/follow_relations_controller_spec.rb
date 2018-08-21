# TODO(Shokei Takanashi) : 最低限の型チェックしかテストしていないので、条件分岐などを考慮したテストも追記する。
require "rails_helper"

describe Api::User::FollowRelationsController, type: :request do
  include_context "APIを認証済み状態にする"

  describe "PATCH #update" do
    subject { patch api_user_follow_relation_path(following_user_id: following_user_id, followed_user_id: followed_user_id) }
    let(:followed_user_id) { following_user.id }
    let(:following_user_id) { followed_user.id }
    let(:following_user) { create(:user) }
    let(:followed_user) { create(:user) }

    context "followed_user_idとfollowing_user_idに該当するレコードが登録されている場合" do
      let(:follow_relation) { create(:user_follow_relation, following_user_id: following_user_id, followed_user_id: followed_user_id) }
      before { follow_relation }

      it "レコードが削除されること" do
        expect{ subject }.to change(User::FollowRelation, :count).by(-1)
        expect(User::FollowRelation.exists?(id: follow_relation.id)).to eq false
      end

      it "is_follow_relationにfalseが格納されて返されること" do
        subject
        expect(JSON.parse(response.body)["follow_id"]).to eq nil
      end

      it "changesテーブルのeventがdeleteとして登録されること" do
        expect{ subject }.to change(User::FollowRelationChange, :count).by(1)
        expect(User::FollowRelationChange.last&.user_follow_relation_id).to eq follow_relation.id
        expect(User::FollowRelationChange.last&.event).to eq "delete"
      end
    end

    context "followed_user_idとfollowing_user_idに該当するレコードが登録されていない場合" do
      it "レコードが登録されること" do
        expect{ subject }.to change(User::FollowRelation, :count).by(1)
      end

      it "is_follow_relationにtrueが格納されて返されること" do
        subject
        expect(JSON.parse(response.body)["follow_id"]).to eq User::FollowRelation.last&.id
      end

      it "changesテーブルのeventがcreateとして登録されること" do
        expect{ subject }.to change(User::FollowRelationChange, :count).by(1)
        expect(User::FollowRelationChange.last&.user_follow_relation_id).to eq User::FollowRelation.last.id
        expect(User::FollowRelationChange.last&.event).to eq "create"
      end
    end
  end
end
