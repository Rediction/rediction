import $ from "jquery";
import * as React from "react";
import ReactDOM from "react-dom";
import WordsCardList from "../../components/organisms/WordsCardList";
import { WordFetcherInterface } from "../../providers/BaseFetcher";
import FollowHandler from "../../providers/FollowHandler";
import ScopedUserFetcher from "../../providers/Word/ScopedUserFetcher";

// Word一覧を表示する対象のID
const targetIdAttr = "words-list";

// ログイン中のユーザーのID
const currentUserId = $(`#${targetIdAttr}`).data("current-user-id");

// 表示中のページのユーザーのID
const userId = $(`#${targetIdAttr}`).data("user-id");

// Word一覧をAPI経由で取得するクラスのインスタンス
// 現在表示中のページのユーザーが投稿したWordのみを取得する。
const scopedUserFetcher: WordFetcherInterface = new ScopedUserFetcher(userId);

ReactDOM.render(
  <WordsCardList
    wordFethcer={scopedUserFetcher}
    targetIdAttr={targetIdAttr}
    userId={currentUserId}
  />,
  document.getElementById(targetIdAttr)
);

/*----- 以下、フォロー関係の処理 -----*/

const followHandler: FollowHandler = new FollowHandler(currentUserId, userId);

// TODO (Shokei Takanashi)
// Reactで生成している範囲外のDOMに対する操作なので、JQueryでイベントをつけているが、
// 全体をReactに変更していく段階で、このイベント処理もReactで行うようにする。
const toggleFollowStatus = async () => {
  const followId = await followHandler.toggleFollowStatus();

  // TODO(Shokei Takanashi)
  // JS側にテキストを持たないでいいように、デザイン実装時にクラスの切り替えで表示を切り替えられるように修正する。
  if (followId) {
    $("#toggle-follow-btn").text("フォロー中");
  } else {
    $("#toggle-follow-btn").text("フォロー");
  }
};

$("#toggle-follow-btn").on("click", toggleFollowStatus);