class PasswordValidator < ActiveModel::EachValidator
  PASSWORD_SYMBOL = '!@#$%?\/+\-'
  VALID_PASSWORD_REGEX =
    /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[#{PASSWORD_SYMBOL}])[a-zA-Z0-9#{PASSWORD_SYMBOL}]{8,32}\z/

  def validate_each(record, attribute, value)
    record.errors.add(attribute, "の形式が正しくありません。") unless value =~ VALID_PASSWORD_REGEX
  end
end
