json.words(words) do |word|
  json.partial! "api/partials/word", locals: {word: word}

  # TODO (Shokei Takanashi)
  # 本来、以下のようにsubqueryを生成し、それをleft joinするの方が後々低負荷なのだが、
  # 現状況でActiverecordでsubqueryのleft joinを実現するのが困難だったため、
  # 暫定的に紐づくfavoritesを全てleft joinして、その中に現在ログイン中のアカウントと一致するものがあるかどうかを
  # APP側で判定し取得するようにしている。
  # wordに紐づくfavoritesの数が増えてイテレート処理が高負荷になってくる前に、subqueryをleft joinする実装に改修する。
  #
  # 本来発行すべきSQLの形式例
  # LEFT JOIN
  #   (select * from favorites where favorites.user_id = :current_user_id)
  #     as favorites
  # ON
  #   favorites.word_id = words.id
  #
  json.favorite_id word.favorites.target.select { |v| v.user_id == @current_user_id }.first&.id

  json.profile do
    if word.user.profile.present?
      json.partial! "api/partials/user/profile", locals: {profile: word.user.profile}
    else
      json.profile nil
    end
  end
end
