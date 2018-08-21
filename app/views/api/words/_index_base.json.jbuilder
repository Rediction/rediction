json.words(words) do |word|
  json.partial! "api/partials/word", locals: {word: word}
  json.favorite_id word.favorites.first&.id

  json.profile do
    if word.user.profile.present?
      json.partial! "api/partials/user/profile", locals: {profile: word.user.profile}
    else
      json.profile nil
    end
  end
end
