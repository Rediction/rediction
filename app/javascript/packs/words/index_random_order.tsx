import * as React from "react";
import ReactDOM from "react-dom";
import WordsCardList from "../../components/organisms/WordsCardList";
import { WordFetcherInterface } from "../../providers/BaseFetcher";
import WordsOrderRandomFetcher from "../../providers/Word/OrderRandomFetcher";

// Word一覧を表示する対象のID
const targetIdAttr = "words-list";

// Word一覧をAPI経由で取得するクラスのインスタンス
// 全Wordからランダムで取得する。
const wordsOrderRandomFetcher: WordFetcherInterface = new WordsOrderRandomFetcher();

ReactDOM.render(
  <WordsCardList
    wordFethcer={wordsOrderRandomFetcher}
    targetIdAttr={targetIdAttr}
  />,
  document.getElementById(targetIdAttr)
);
