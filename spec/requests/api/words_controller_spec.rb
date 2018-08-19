# TODO(Shokei Takanashi) : 最低限の方チェックしかテストしていないので、条件分岐などを考慮したテストも追記する。
require "rails_helper"

describe Api::WordsController, type: :request do
  include_context 'APIを認証済み状態にする'

  shared_context "ページネーションの規定値分の値が取れること" do
    it do
      is_expected.to eq 200
      expect(JSON.parse(response.body)["words"].count).to eq Api::WordsController::FETCH_COUNT
    end
  end

  describe "GET #index_latest_order" do
    subject { get index_latest_order_api_words_path(last_fetched_word_id: last_fetched_word_id) }
    let(:last_fetched_word_id) { nil }

    context "平常時アクセスの場合" do
      it "返り値のKeyの値が適切であること", :aggregate_failures do
        is_expected.to eq 200
        expect(response.body).to have_json_type(Array).at_path("words")
      end
    end

    context "Wordがページネーションの規定数以上登録されている場合" do
      before { create_list(:word_with_profile, Api::WordsController::FETCH_COUNT + 1) }

      include_context "ページネーションの規定値分の値が取れること"
    end
  end

  describe "GET #index_random_order" do
    subject { get index_random_order_api_words_path(last_fetched_word_id: last_fetched_word_id) }
    let(:last_fetched_word_id) { nil }

    context "平常時アクセスの場合" do
      it "返り値のKeyの値が適切であること", :aggregate_failures do
        is_expected.to eq 200
        expect(response.body).to have_json_type(Array).at_path("words")
        expect(response.body).to have_json_type(String).at_path("token")
      end

      it "tokenに最後に生成したトークンが格納されていること", :aggregate_failures do
        is_expected.to eq 200
        expect(response.body).to have_json_type(Array).at_path("words")
        expect(response.body).to be_json_eql(%("#{Word::RandomFetchedToken.last.token}")).at_path("token")
      end
    end

    context "Wordがページネーションの規定数以上登録されている場合" do
      before { create_list(:word_with_profile, Api::WordsController::FETCH_COUNT + 1) }

      include_context "ページネーションの規定値分の値が取れること"
    end
  end

  describe "GET #index_scoped_favorite_words" do
    subject { get index_scoped_favorite_words_api_words_path(last_fetched_favorite_id: last_fetched_favorite_id) }
    let(:last_fetched_favorite_id) { nil }

    context "平常時アクセスの場合" do
      it "返り値のKeyの値が適切であること", :aggregate_failures do
        is_expected.to eq 200
        expect(response.body).to have_json_type(Array).at_path("words")
      end
    end
  end

  describe "GET #index_scoped_follow_users" do
    subject { get index_scoped_follow_users_api_words_path(last_fetched_word_id: last_fetched_word_id) }
    let(:last_fetched_word_id) { nil }

    context "平常時アクセスの場合" do
      it "返り値のKeyの値が適切であること", :aggregate_failures do
        is_expected.to eq 200
        expect(response.body).to have_json_type(Array).at_path("words")
      end
    end
  end

  describe "GET #index_scoped_user" do
    subject { get index_scoped_user_api_words_path(last_fetched_word_id: last_fetched_word_id, user_id: user.id) }
    let(:last_fetched_word_id) { nil }
    let(:user) { create(:user_with_profile) }

    context "平常時アクセスの場合" do
      it "返り値のKeyの値が適切であること", :aggregate_failures do
        is_expected.to eq 200
        expect(response.body).to have_json_type(Array).at_path("words")
      end
    end

    context "Wordがページネーションの規定数以上登録されている場合" do
      before do
        (Api::WordsController::FETCH_COUNT + 1).times do
          create(:word, user: user)
        end
      end

      include_context "ページネーションの規定値分の値が取れること"
    end
  end
end
