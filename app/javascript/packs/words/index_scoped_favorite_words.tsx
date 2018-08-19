import * as React from "react";
import ReactDOM from "react-dom";
import WordsCardList from "../../components/organisms/WordsCardList";
import { WordFetcherInterface } from "../../providers/BaseFetcher";
import ScopedFavoriteWordsFetcher from "../../providers/Word/ScopedFavoriteWordsFetcher";

// Word一覧を表示する対象のID
const targetIdAttr = "words-list";

// Word一覧をAPI経由で取得するクラスのインスタンス
// お気に入り登録中のWordのみを取得する。
const scopedFavoriteWordsFetcher: WordFetcherInterface = new ScopedFavoriteWordsFetcher();

ReactDOM.render(
  <WordsCardList
    wordFethcer={scopedFavoriteWordsFetcher}
    targetIdAttr={targetIdAttr}
  />,
  document.getElementById(targetIdAttr)
);
