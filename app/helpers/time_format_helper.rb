module TimeFormatHelper
  # 日時(datetime型)を全て日本語名に変換
  def ja_full_datetime(datetime)
    datetime.strftime("%Y年%m月%d日 %H時間%M分%S秒")
  end

  # 日時(datetime型)を分単位まで日本語名に変換
  def ja_middle_datetime(datetime)
    datetime.strftime("%Y年%m月%d日 %H時間%M分")
  end

  # 日付(date型)を全て日本語名に変換
  def ja_full_date(date)
    date.strftime("%Y年%m月%d日")
  end
end
