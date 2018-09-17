json.words(words) do |word|
  json.partial! "api/partials/word", locals: {word: word}

  # ログイン中のユーザーがwordをお気に入り登録中かどうかを示すフラグ
  json.favorited @favorite_word_ids.include?(word.id)

  json.profile do
    if word.user.profile.present?
      json.partial! "api/partials/user/profile", locals: {profile: word.user.profile}
    else
      json.profile nil
    end
  end
end
