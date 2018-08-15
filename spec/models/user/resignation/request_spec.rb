# == Schema Information
#
# Table name: user_resignation_requests # ユーザーの退会申請が格納されるテーブル
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID
#  description :string(255)      not null              # 凍結解除理由
#  created_at  :datetime         not null
#

require "rails_helper"

RSpec.describe User::Resignation::Request, type: :model do
  describe "Instanceメソッド" do
    let(:resignation_request) { build(:user_resignation_request) }

    describe "#save_and_resign_user!" do
      subject { resignation_request.save_and_resign_user! }

      context "登録処理に成功した場合" do
        it "レコードが登録されること" do
          expect{ subject }.to change(User::Resignation::Request, :count).by(1).and change(UserChange, :count).by(1)
        end

        it "ユーザーの退会状態がtrue(退会済み)に更新されること" do
          expect{ subject }.to change{ resignation_request.user.reload.resigned? }.from(false).to(true)
        end

        it "ユーザーのchangesテーブルに退会済みステータスのレコードが登録されていること" do
          expect{ subject }.to change{ UserChange.last&.resigned? }.from(nil).to(true)
        end

        it "selfが返ってくること" do
          expect(subject).to eq resignation_request
        end
      end

      context "登録処理に失敗した場合" do
        let(:resignation_request) { build(:user_resignation_request, description: description) }
        let(:description) { "abcde" * 141 }

        it "ActiveRecord::RecordInvalidが発生して、レコードの更新がないこと", :aggregate_failures do
          expect{ subject }.to raise_error(ActiveRecord::RecordInvalid).and change(User::Resignation::Request, :count).by(0).and change(UserChange, :count).by(0)
          expect(resignation_request.user.reload.unresigned?).to eq true
        end
      end
    end
  end
end
