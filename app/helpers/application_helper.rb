module ApplicationHelper
  # 改行を <br /> に変換
  def br(string)
    unless string.html_safe?
      string = h(string)
    end

    string.gsub(/\r\n|\r|\n/, "<br />").html_safe
  end
end
