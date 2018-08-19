import * as React from "react";
import ReactDOM from "react-dom";
import SearchedWordsCardList from "../../components/organisms/SearchedWordsCardList";

// Word一覧を表示する対象のID
const targetIdAttr = "words-list";
const searchFieldIdAttr = "search-field";
const searchBtnIdAttr = "search-btn";

ReactDOM.render(
  <SearchedWordsCardList
    targetIdAttr={targetIdAttr}
    searchFieldIdAttr={searchFieldIdAttr}
    searchBtnIdAttr={searchBtnIdAttr}
  />,
  document.getElementById(targetIdAttr)
);
