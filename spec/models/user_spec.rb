# == Schema Information
#
# Table name: users # ユーザー情報
#
#  id              :bigint(8)        not null, primary key
#  email           :string(255)      not null                        # メールアドレス
#  password_digest :string(255)      not null                        # パスワード
#  freezed         :boolean          default("unfreezed"), not null  # 凍結状態
#  resigned        :boolean          default("unresigned"), not null # 退会状態
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require "rails_helper"

RSpec.describe User, type: :model do
  include_context 'Changesテーブルを有する場合', User

  describe "Instanceメソッド" do
    describe "#followed_user" do
      subject { user.followed_user?(followed_user) }
      let(:user) { create(:user) }
      let(:followed_user) { create(:user) }

      context "ユーザー(引数)がフォロー中の場合" do
        before { create(:user_follow_relation, following_user: user, followed_user: followed_user) }

        it "trueが返されること" do
          is_expected.to eq true
        end
      end

      context "ユーザー(引数)がフォローされていない場合" do
        it "falseが返されること" do
          is_expected.to eq false
        end
      end
    end
  end
end
