# == Schema Information
#
# Table name: user_resignation_request_cancels # ユーザーの退会申請のキャンセルが格納されるテーブル
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID
#  description :string(255)      not null              # 退会キャンセル理由
#  created_at  :datetime         not null
#

require "rails_helper"

RSpec.describe User::Resignation::RequestCancel, type: :model do
  describe "Instanceメソッド" do
    let(:resignation_request_cancel) { build(:user_resignation_request_cancel, user: user) }
    let(:user) { create(:user, resigned: :resigned) }

    describe "#save_and_cancel_resign_request!" do
      subject { resignation_request_cancel.save_and_cancel_resign_request! }

      context "登録処理に成功した場合" do
        it "レコードが登録されること" do
          expect{ subject }.to change(User::Resignation::RequestCancel, :count).by(1).and change(UserChange, :count).by(1)
        end

        it "ユーザーの退会状態がfalse(未退会)に更新されること" do
          expect{ subject }.to change{ resignation_request_cancel.user.reload.unresigned? }.from(false).to(true)
        end

        it "ユーザーのchangesテーブルに未退会ステータスのレコードが登録されていること" do
          expect{ subject }.to change{ UserChange.last&.unresigned? }.from(nil).to(true)
        end

        it "selfが返ってくること" do
          expect(subject).to eq resignation_request_cancel
        end
      end

      context "登録処理に失敗した場合" do
        let(:resignation_request_cancel) { build(:user_resignation_request_cancel, user: user, description: description) }
        let(:description) { "abcde" * 141 }

        it "ActiveRecord::RecordInvalidが発生して、レコードの更新がないこと", :aggregate_failures do
          expect{ subject }.to raise_error(ActiveRecord::RecordInvalid).and change(User::Resignation::RequestCancel, :count).by(0).and change(UserChange, :count).by(0)
          expect(resignation_request_cancel.user.reload.resigned?).to eq true
        end
      end
    end
  end
end
