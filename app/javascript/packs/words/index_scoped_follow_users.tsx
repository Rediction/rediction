import $ from "jquery";
import * as React from "react";
import ReactDOM from "react-dom";
import WordsCardList from "../../components/organisms/WordsCardList";
import { WordFetcherInterface } from "../../providers/BaseFetcher";
import ScopedFollowUsersFetcher from "../../providers/Word/ScopedFollowUsersFetcher";
import { setWordChangeModeMenuAction } from "./_index_nav";

// Word一覧を表示する対象のID
const targetIdAttr = "words-list";

// ログイン中のユーザーのID
const currentUserId = $(`#${targetIdAttr}`).data("current-user-id");

// Word一覧をAPI経由で取得するクラスのインスタンス
// フォロー中のユーザーが投稿したWordのみを取得する。
const scopedFollowUsersFetcher: WordFetcherInterface = new ScopedFollowUsersFetcher(
  currentUserId
);

ReactDOM.render(
  <WordsCardList
    wordFethcer={scopedFollowUsersFetcher}
    targetIdAttr={targetIdAttr}
    userId={currentUserId}
  />,
  document.getElementById(targetIdAttr)
);

// Word一覧切り替え用メニューの表示・非表示イベントを設定
setWordChangeModeMenuAction();
