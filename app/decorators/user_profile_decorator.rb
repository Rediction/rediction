module UserProfileDecorator
  def full_name(space = true)
    first_name + (space ? " " : "") + last_name
  end

  def age
    # 年月日を8桁の数字に直して引いた後、5桁目(年１桁目)が１桁目に来るように10000で割っている
    (Time.current.strftime("%Y%m%d").to_i - birth_on.strftime("%Y%m%d").to_i) / 10000
  end
end
