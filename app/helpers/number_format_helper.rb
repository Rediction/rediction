module NumberFormatHelper
  # 数字をカンマで３桁区切りにする処理
  def separate_comma(number)
    number.to_s(:delimited, delimiter: ',')
  end
end
