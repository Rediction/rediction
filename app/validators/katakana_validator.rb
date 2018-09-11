class KatakanaValidator < ActiveModel::EachValidator
  # 形式をカタカナに指定するもの
  VALID_KATAKANA_REGEX = /\A[ァ-ヴー]+\z/

  def validate_each(record, attribute, value)
    record.errors.add(attribute, "にはカタカナのみが使用できます。") unless value =~ VALID_KATAKANA_REGEX
  end
end
