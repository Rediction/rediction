json.follow_relations(@follow_relations) do |follow_relation|
  json.id follow_relation.id

  json.user do
    json.partial! "api/partials/user", locals: {user: follow_relation.followed_user}
  end

  if follow_relation.followed_user.profile.present?
    json.profile do
      json.partial! "api/partials/user/profile", locals: {profile: follow_relation.followed_user.profile}
    end
  else
    json.profile nil
  end

  # 最終投稿日時
  if follow_relation.followed_user.words&.last&.created_at.present?
    json.latest_word_ja_created_at ja_full_date(follow_relation.followed_user.words&.last&.created_at)
  else
    json.latest_word_ja_created_at nil
  end
end
