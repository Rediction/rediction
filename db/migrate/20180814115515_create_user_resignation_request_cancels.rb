class CreateUserResignationRequestCancels < ActiveRecord::Migration[5.2]
  def change
    create_table :user_resignation_request_cancels, comment: "ユーザーの退会申請のキャンセルが格納されるテーブル" do |t|
      t.references :user, null: false, index: true, comment: "ユーザーID"
      t.string :description, null: false, comment: "退会キャンセル理由"
      t.datetime :created_at, null: false
    end
  end
end
