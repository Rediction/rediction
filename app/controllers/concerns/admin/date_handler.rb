module Admin::DateHandler
  FETCHABLE_MAX_DAYS = 100

  # 日付をキーとしたハッシュの空いた日付を0で埋める
  def fill_missing_date_with_zero(daily_hash, start_date, end_date)
    (start_date..end_date).map do |date|
      if daily_hash[date].present?
        { date => daily_hash[date] }
      else
        { date => 0 }
      end
    end.reduce(:merge)
  end

  # 取得対象期間の日付を取得
  def fetch_target_period_dates(start_date, end_date)
    start_date = start_date.present? ? params[:start_date].to_date : 30.days.ago.to_date

    end_date = end_date.present? ? end_date.to_date : Time.current.to_date

    end_date = start_date + FETCHABLE_MAX_DAYS if start_date + FETCHABLE_MAX_DAYS < end_date

    return start_date, end_date
  end

  # 配列を日付をkeyにしたハッシュに変換
  def array_to_daily_hash(array, key_name)
    array.length > 0 ? array.map{ |v| { v["date_at"] => v[key_name] } }.reduce(:merge) : {}
  end
end
