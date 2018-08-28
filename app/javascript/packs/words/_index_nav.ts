import $ from "jquery";

// Word一覧切り替え用メニューの表示・非表示イベントを設定
export const setWordChangeModeMenuAction = () => {
  $(document).on(
    "click",
    "#word-change-mode-menu-btn",
    toggleWordChangeModeMenu
  );

  $(document).on("click", "#word-change-mode-menu", e => {
    if ($(e.target).closest("a").length === 1) {
      return;
    }
    toggleWordChangeModeMenu();
  });
};

// word-change-mode-menuの表示・非表示を切り替え
const toggleWordChangeModeMenu = () => {
  $("#word-change-mode-menu").toggleClass("active");
};
