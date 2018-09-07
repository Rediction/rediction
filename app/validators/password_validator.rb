class PasswordValidator < ActiveModel::EachValidator
  SYMBOL = '!@#$%?\/+\-'
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[#{SYMBOL}])[a-zA-Z0-9#{SYMBOL}]+\z/

  def validate_each(record, attribute, value)
    return record.errors.add(attribute, "の形式が正しくありません。") if value.match(VALID_PASSWORD_REGEX).blank?

    record.errors.add(attribute, "の長さは8文字以上32文字以内です。") if value.length < 8 || value.length > 32
  end
end
