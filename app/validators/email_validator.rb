class EmailValidator < ActiveModel::EachValidator
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def validate_each(record, attribute, value)
    record.errors.add(attribute, "の形式が正しくありません。") if value.match(VALID_EMAIL_REGEX).blank?
  end
end
