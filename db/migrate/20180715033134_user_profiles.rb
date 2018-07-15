class UserProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_profiles do |t|
      t.bigint  :user_id,         null: false, uniqueness: true,  comment: "ユーザーID"
      t.string  :last_name,       null: false, comment: "苗字"
      t.string  :last_name_kana,  null: false, comment: "苗字(フリガナ)"
      t.string  :first_name,      null: false, comment: "名前"
      t.string  :first_name_kana, null: false, comment: "名前(フリガナ)"
      t.date    :birth_on,        null: false, comment: "生年月日"
      t.string  :job,             null: false, comment: "職業"
      t.timestamps
    end
  end
end
