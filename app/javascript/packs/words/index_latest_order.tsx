import $ from "jquery";
import * as React from "react";
import ReactDOM from "react-dom";
import WordsCardList from "../../components/organisms/WordsCardList";
import { WordFetcherInterface } from "../../providers/BaseFetcher";
import WordOrderLatestFetcher from "../../providers/Word/OrderLatestFetcher";

// Word一覧を表示する対象のID
const targetIdAttr = "words-list";

// ログイン中のユーザーのID
const currentUserId = $(`#${targetIdAttr}`).data("current-user-id");

// Word一覧をAPI経由で取得するクラスのインスタンス
// 現在のログイン中のユーザーが投稿したWordのみを取得する。
const wordOrderLatestFetcher: WordFetcherInterface = new WordOrderLatestFetcher(
  currentUserId
);

ReactDOM.render(
  <WordsCardList
    wordFethcer={wordOrderLatestFetcher}
    targetIdAttr={targetIdAttr}
    userId={currentUserId}
  />,
  document.getElementById(targetIdAttr)
);
