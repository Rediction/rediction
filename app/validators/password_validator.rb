class PasswordValidator < ActiveModel::EachValidator
  ALLOW_PASSWORD_SYMBOL = '!@#$%?\/+\-'

  # パスワードの形式を、半角大文字英字、半角小文字英字、半角数字、記号の４つを許容してこの４つを必ず含んだものに指定するもの
  VALID_PASSWORD_REGEX =
    /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[#{ALLOW_PASSWORD_SYMBOL}])[a-zA-Z0-9#{ALLOW_PASSWORD_SYMBOL}]{8,32}\z/

  def validate_each(record, attribute, value)
    record.errors.add(attribute, "の形式が正しくありません。") unless value =~ VALID_PASSWORD_REGEX
  end
end
