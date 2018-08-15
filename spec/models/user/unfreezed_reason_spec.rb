# == Schema Information
#
# Table name: user_unfreezed_reasons # ユーザーのアカウント凍結解除記録
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  description :string(255)      not null              # 凍結解除理由
#  created_at  :datetime         not null
#

require "rails_helper"

RSpec.describe User::UnfreezedReason, type: :model do
  describe "Instanceメソッド" do
    let(:unfreezed_reason) { build(:user_unfreezed_reason, user: user) }
    let(:user) { create(:user, freezed: :freezed) }

    describe "#save_and_lift_user_freeze!" do
      subject { unfreezed_reason.save_and_lift_user_freeze! }

      context "登録処理に成功した場合" do
        it "レコードが登録されること" do
          expect{ subject }.to change(User::UnfreezedReason, :count).by(1).and change(UserChange, :count).by(1)
        end

        it "ユーザーの凍結状態がfalse(未凍結)に更新されること" do
          expect{ subject }.to change{ unfreezed_reason.user.reload.unfreezed? }.from(false).to(true)
        end

        it "ユーザーのchangesテーブルに未凍結ステータスのレコードが登録されていること" do
          expect{ subject }.to change{ UserChange.last&.unfreezed? }.from(nil).to(true)
        end

        it "selfが返ってくること" do
          expect(subject).to eq unfreezed_reason
        end
      end

      context "登録処理に失敗した場合" do
        let(:unfreezed_reason) { build(:user_unfreezed_reason, user: user, description: description) }
        let(:description) { "abcde" * 141 }

        it "ActiveRecord::RecordInvalidが発生して、レコードの更新がないこと", :aggregate_failures do
          expect{ subject }.to raise_error(ActiveRecord::RecordInvalid).and change(User::UnfreezedReason, :count).by(0).and change(UserChange, :count).by(0)
          expect(unfreezed_reason.user.reload.freezed?).to eq true
        end
      end
    end
  end
end
