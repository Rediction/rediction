module DateSelectHelper
  # 生年月日用のフォーム(セレクター形式)を出力
  def birth_date_selector(form_object)
    default_age = 20

    select_field = custom_date_selector(
      form_object: form_object,
      column: :birth_on,
      start_year: UserProfile::MAXIMUM_AGE.years.ago.year,
      end_year: UserProfile::MINIMUM_AGE.years.ago.year,
      default: default_age.years.ago.year
    )

    "<div class='birth-on-field'>#{select_field}</div>".html_safe
  end

  private

  # 標準ヘルパーのdate_selectを年月日区切りで、それぞれのselectタグをクラスで囲い出力
  def custom_date_selector(form_object:, column:, start_year:, end_year:, default:)
    sprintf(
      (
        form_object.date_select(
          column,
          use_month_numbers: true,
          start_year: start_year,
          end_year: end_year,
          default: default
        ).gsub(/(<select)/, '<div class="date-select-field">\1')
         .gsub(/(<\/select>)/, '\1</div>%s')
      ), '<p>年</p>', '<p>月</p>', '<p>日</p>'
    ).html_safe
  end
end
