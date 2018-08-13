// Mobile用のヘッダーのToggle処理
$(document).on("click", "#header-menu, #header-menu-overlay", function () {
  if ($("#side-menu").hasClass("active")) {
    $("#side-menu, #header-menu-overlay").removeClass("active");
  } else {
    $("#side-menu, #header-menu-overlay").addClass("active");
  }
});
