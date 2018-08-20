module UserProfileDecorator
  def full_name(space = true)
    first_name + (space ? " " : "") + last_name
  end
end
