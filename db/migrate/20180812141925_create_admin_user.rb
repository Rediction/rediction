class CreateAdminUser < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_users, comment: "管理者ユーザー" do |t|
      t.string :email, null: false, index: { unique: true }, comment: "メールアドレス"
      t.string :uid, null: true, comment: "OAuth用のユニークID"
      t.datetime :created_at, null: false
    end
  end
end
