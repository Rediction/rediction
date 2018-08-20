json.words(words) do |word|
  json.partial! "api/partials/word", locals: {word: word}
  json.is_favorite word.favorites.present?

  json.profile do
    json.partial! "api/partials/user/profile", locals: {profile: word.user.profile}
  end
end
