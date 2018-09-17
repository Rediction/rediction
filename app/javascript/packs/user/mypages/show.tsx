import $ from "jquery";
import * as React from "react";
import ReactDOM from "react-dom";
import WordsCardList from "../../../components/organisms/WordsCardList";
import { WordFetcherInterface } from "../../../providers/BaseFetcher";
import ScopedUserFetcher from "../../../providers/Word/ScopedUserFetcher";

// Word一覧を表示する対象のID
const targetIdAttr = "words-list";

// ログイン中のユーザーのID
const currentUserId = $(`#${targetIdAttr}`).data("current-user-id");

// Word一覧をAPI経由で取得するクラスのインスタンス
// 現在のログイン中のユーザーが投稿したWordのみを取得する。
const scopedUserFetcher: WordFetcherInterface = new ScopedUserFetcher(
  currentUserId, currentUserId
);

ReactDOM.render(
  <WordsCardList
    wordFethcer={scopedUserFetcher}
    targetIdAttr={targetIdAttr}
    currentUserId={currentUserId}
  />,
  document.getElementById(targetIdAttr)
);

// マイページの設定メニューの表示・非表示イベントを設定
$(document).on("click", "#configure-menu-btn, #configure-menu-overlay", () => {
  $("#configure-menu").toggleClass("active");
});
