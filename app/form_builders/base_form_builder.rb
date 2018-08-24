# フォーム下にエラーメッセージが表示されるようにカスタムしたフォームビルダー。
# FormBuildHelper#base_form_for(ヘルパー)を利用することで、for_forの代わりに利用できる。
#
# Labelを含めたHTMLを全て生成するようにしてもいいが、
# 近いうちにSPAにして、フォーム自体をReact.jsで管理する可能性が高いので、
# 今の段階では、シンプルにエラー表示だけにしている。
# もしもSPAにせずに、Rails側にViewを置くことにした場合は、Labelを含めたHTMLを生成するようにしてもよい。

class BaseFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, args = {})
    super + error(attribute)
  end

  def url_field(attribute, args = {})
    super + error(attribute)
  end

  def text_area(attribute, args = {})
    super + error(attribute)
  end

  def file_field(attribute, args = {})
    super + error(attribute)
  end

  def email_field(attribute, args = {})
    super + error(attribute)
  end

  def password_field(attribute, args = {})
    super + error(attribute)
  end

  private

  def error(attribute)
    error_html(error_message(attribute))
  end

  def error_message(attribute)
    return "" if @object.errors[attribute].size == 0

    model_name = @object.model_name.name.underscore
    I18n.t("activerecord.attributes.#{model_name}.#{attribute}") + @object.errors[attribute].first
  end

  def error_html(msg)
    return "" if msg.blank?

    @template.content_tag(:p, class: "has-error") do
      msg
    end
  end
end
