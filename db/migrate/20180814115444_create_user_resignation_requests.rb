class CreateUserResignationRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :user_resignation_requests, comment: "ユーザーの退会申請が格納されるテーブル" do |t|
      t.references :user, null: false, index: true, comment: "ユーザーID"
      t.string :description, null: false, comment: "凍結解除理由"
      t.datetime :created_at, null: false
    end
  end
end
