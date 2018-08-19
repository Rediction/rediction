import * as React from "react";
import ReactDOM from "react-dom";
import WordsCardList from "../../components/organisms/WordsCardList";
import { WordFetcherInterface } from "../../providers/BaseFetcher";
import ScopedFollowUsersFetcher from "../../providers/Word/ScopedFollowUsersFetcher";

// Word一覧を表示する対象のID
const targetIdAttr = "words-list";

// Word一覧をAPI経由で取得するクラスのインスタンス
// フォロー中のユーザーが投稿したWordのみを取得する。
const scopedFollowUsersFetcher: WordFetcherInterface = new ScopedFollowUsersFetcher();

ReactDOM.render(
  <WordsCardList
    wordFethcer={scopedFollowUsersFetcher}
    targetIdAttr={targetIdAttr}
  />,
  document.getElementById(targetIdAttr)
);