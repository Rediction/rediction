# TODO(Shokei Takanashi) : 最低限の型チェックしかテストしていないので、条件分岐などを考慮したテストも追記する。
require "rails_helper"

describe Api::Users::FollowRelationsController, type: :request do
  include_context "APIを認証済み状態にする"

  let(:fetch_count) { Api::Users::FollowRelationsController::FETCH_COUNT }

  describe "GET #index" do
    subject { get api_user_follow_relations_path(user_id: user_id, last_fetched_word_id: last_fetched_word_id) }
    let(:user_id) { user.id }
    let(:user) { create(:user_with_profile) }
    let(:last_fetched_word_id) { 1 }

    context "平常時アクセスの場合" do
      before do
        fetch_count.times do
          followed_user = create(:user_with_profile)
          create(:user_follow_relation, following_user: user, followed_user: followed_user)
        end
      end

      it "返り値のKeyの値が適切であること", :aggregate_failures do
        is_expected.to eq 200
        expect(response.body).to have_json_type(Array).at_path("users")
      end

      it "ページネーションの規定値分の値が取れること" do
        is_expected.to eq 200
        expect(JSON.parse(response.body)["users"].count).to eq fetch_count
      end
    end
  end
end
