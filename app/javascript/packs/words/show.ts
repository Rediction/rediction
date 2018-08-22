import $ from "jquery";
import FavoriteHandler from "../../providers/FavoriteHandler";

const wordId = $("#show-word").data("word-id");
const currentUserId = $("#show-word").data("current-user-id");

const favoriteHandler: FavoriteHandler = new FavoriteHandler(
  wordId,
  currentUserId
);

const toggleFavoriteStatus = async () => {
  // API通信が完了する前に見た目上だけ切り替える。
  $("#show-word-sub-favorite").toggleClass("active");

  const favoriteId:
    | number
    | boolean
    | null = await favoriteHandler.toggleFavoriteStatus();

  // falseが返された時は処理を中断
  if (favoriteId === false) {
    return;
  }

  if (favoriteId) {
    $("#show-word-sub-favorite").addClass("active");
  } else {
    $("#show-word-sub-favorite").removeClass("active");
  }
};

$(document).on("click", "#show-word-sub-favorite", toggleFavoriteStatus);
