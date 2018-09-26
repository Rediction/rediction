// Word#showはReactに起き変えていないため、現状JS処理もjQuery主体になっている。
// 可読性が著しく下がる前にReactに全体を置き換えること。

import $ from "jquery";
import FavoriteHandler, {
  FavoriteHandlerResponse
} from "../../providers/FavoriteHandler";
import NumberFormatter from "../../providers/Formatter/NumberFormatter";

const wordId = $("#show-word").data("word-id");
const currentUserId = $("#show-word").data("current-user-id");

const favoriteHandler: FavoriteHandler = new FavoriteHandler(
  wordId,
  currentUserId
);

const ACTION_FAVORITE_ELM = "#show-word-sub-action-favorite";
const ACTION_FAVORITE_COUNT_ELM = "#show-word-sub-action-favorite-count";

// お気に入り件数の表記を更新
const updateFavoriteCountNotation = (count: number): void => {
  const countNotation: string =
    count !== 0 ? NumberFormatter.separateByComma(count) : "";
  $(ACTION_FAVORITE_COUNT_ELM).text(countNotation);
};

// お気に入りステータス用の事前更新処理
const advanceUpdateForToggleFavoriteStatus = () => {
  const currentFavoriteCount = Number($(ACTION_FAVORITE_COUNT_ELM).text());

  const advanceFavoriteCount = $(ACTION_FAVORITE_ELM).hasClass("active")
    ? currentFavoriteCount - 1
    : currentFavoriteCount + 1;

  updateFavoriteCountNotation(advanceFavoriteCount);
  $(ACTION_FAVORITE_ELM).toggleClass("active");
};

const toggleFavoriteStatus = async () => {
  // API通信が完了する前に見た目上だけ切り替える。
  advanceUpdateForToggleFavoriteStatus();

  const favoriteHandlerResponse: FavoriteHandlerResponse | null = await favoriteHandler.toggleFavoriteStatus();

  // nullが返された時は処理を中断
  if (favoriteHandlerResponse === null) {
    return;
  }

  if (favoriteHandlerResponse.favorited) {
    $(ACTION_FAVORITE_ELM).addClass("active");
  } else {
    $(ACTION_FAVORITE_ELM).removeClass("active");
  }

  updateFavoriteCountNotation(favoriteHandlerResponse.favorite_count);
};

$(document).on("click", ACTION_FAVORITE_ELM, toggleFavoriteStatus);

/*---- ここから、言葉削除用のモーダル処理 -----*/

$(document).on("click", "#show-word-sub-action-trash-icon", () => {
  $("#modal-simple-confirm").addClass("active");
});

$(document).on("click", "#close-modal", () => {
  $("#modal-simple-confirm").removeClass("active");
});

$(document).on("click", "#modal-simple-confirm", e => {
  if ($(e.target).closest("#modal-simple-confirm-cassette").length === 1) {
    return;
  }
  $("#modal-simple-confirm").removeClass("active");
});
