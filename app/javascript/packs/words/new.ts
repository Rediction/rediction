import $ from "jquery";

// フォーム送信処理
$(document).on("click", "#new-word-form-submit-button", () => {
  $("#new-word-form-submit-button").attr("disabled", "disabled");
  $("#new-word-form").submit();
});
