import $ from "jquery";
import * as React from "react";
import ReactDOM from "react-dom";
import WordsCardList from "../../components/organisms/WordsCardList";
import { WordFetcherInterface } from "../../providers/BaseFetcher";
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
