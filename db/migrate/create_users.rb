class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.bigint   :id              #ユーザーid
      t.string   :email           #ユーザーのメールアドレス
      t.string   :password        #ユーザーのパスワード
      t.datetime :created_at      #ユーザーのアカウントが作られた日時
      t.datetime :updated_at      #ユーザーのアカウントが更新された日時
    end
  end
end