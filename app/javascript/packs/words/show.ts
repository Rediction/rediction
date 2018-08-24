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

/*---- ここから、言葉削除用のモーダル処理 -----*/

$(document).on("click", "#show-word-sub-trash-icon", () => {
  $("#modal-simple-confirm").addClass("active");
});

$(document).on("click", "#close-modal", () => {
  $("#modal-simple-confirm").removeClass("active");
});

$(document).on("click", "#modal-simple-confirm", e => {
  if ($(e.target).closest("#modal-simple-confirm-cassette").length === 1) { return; }
  $("#modal-simple-confirm").removeClass("active");
});
