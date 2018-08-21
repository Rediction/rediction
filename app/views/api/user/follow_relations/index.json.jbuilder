json.follow_relations(@follow_relations) do |follow_relation|
  json.user do
    json.partial! "api/partials/user", locals: {user: follow_relation.followed_user}
  end

  json.profile do
    if follow_relation.followed_user.profile.present?
      json.partial! "api/partials/user/profile", locals: {profile: follow_relation.followed_user.profile}
    else
      json.profile nil
    end
  end
end
