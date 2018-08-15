# == Schema Information
#
# Table name: user_freezed_reasons # ユーザーのアカウント凍結記録
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  description :string(255)      not null              # 凍結理由
#  created_at  :datetime         not null
#

require "rails_helper"

RSpec.describe User::FreezedReason, type: :model do
  describe "Instanceメソッド" do
    let(:freezed_reason) { build(:user_freezed_reason) }

    describe "#save_and_freeze_user!" do
      subject { freezed_reason.save_and_freeze_user! }

      context "登録処理に成功した場合" do
        it "レコードが登録されること" do
          expect{ subject }.to change(User::FreezedReason, :count).by(1).and change(UserChange, :count).by(1)
        end

        it "ユーザーの凍結状態がtrue(凍結済み)に更新されること" do
          expect{ subject }.to change{ freezed_reason.user.reload.freezed? }.from(false).to(true)
        end

        it "ユーザーのchangesテーブルに凍結済みステータスのレコードが登録されていること" do
          expect{ subject }.to change{ UserChange.last&.freezed? }.from(nil).to(true)
        end

        it "selfが返ってくること" do
          expect(subject).to eq freezed_reason
        end
      end

      context "登録処理に失敗した場合" do
        let(:freezed_reason) { build(:user_freezed_reason, description: description) }
        let(:description) { "abcde" * 141 }

        it "ActiveRecord::RecordInvalidが発生して、レコードの更新がないこと", :aggregate_failures do
          expect{ subject }.to raise_error(ActiveRecord::RecordInvalid).and change(User::FreezedReason, :count).by(0).and change(UserChange, :count).by(0)
          expect(freezed_reason.user.reload.unfreezed?).to eq true
        end
      end
    end
  end
end
