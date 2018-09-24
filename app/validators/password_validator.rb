class PasswordValidator < ActiveModel::EachValidator
  ALLOW_PASSWORD_SYMBOL = '!@#$%?\/+\-'

  # 半角大文字英字、半角小文字英字、半角数字、記号の４種を許容して、
  # 半角英字、半角数字の2種を必ず含むことを示す正規表現。
  # 文字数は8~32文字に制限している。
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-zA-Z])(?=.*?[0-9])[a-zA-Z0-9#{ALLOW_PASSWORD_SYMBOL}]{8,32}\z/

  def validate_each(record, attribute, value)
    record.errors.add(attribute, "の形式が正しくありません。") unless value =~ VALID_PASSWORD_REGEX
  end
end
