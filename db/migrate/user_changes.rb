class ChangeUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.bigint   :id           #更新されたユーザー情報の順番を示すID
      t.bigint   :user_id      #更新されたユーザー情報の持ち主（ユーザーID）
      t.string   :email        #更新されたユーザーのメールアドレス
      t.string   :password     #更新されたユーザーのパスワード
      t.datetime :created_at   #情報が更新されて新しい情報が作られた日時
    end
  end
end