import $ from "jquery";

// Word一覧切り替え用メニューの表示・非表示イベントを設定
export const setWordChangeModeMenuAction = function() {
  $(document).on("click", "#word-change-mode-menu-btn", function() {
    $("#word-change-mode-menu").toggleClass("active");
  });

  $(document).on("click", "#word-change-mode-menu", function(e) {
    if ($(e.target).closest("a").length === 1) {
      return;
    }
    $("#word-change-mode-menu").toggleClass("active");
  });
};
