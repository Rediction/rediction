import $ from "jquery";
import * as React from "react";
import ReactDOM from "react-dom";
import SearchedWordsCardList from "../../components/organisms/SearchedWordsCardList";

// Word一覧を表示する対象のID
const targetIdAttr = "words-list";
const searchFieldIdAttr = "search-field";
const searchBtnIdAttr = "search-btn";

// ログイン中のユーザーのID
const currentUserId = $(`#${targetIdAttr}`).data("current-user-id");

ReactDOM.render(
  <SearchedWordsCardList
    targetIdAttr={targetIdAttr}
    searchFieldIdAttr={searchFieldIdAttr}
    searchBtnIdAttr={searchBtnIdAttr}
    currentUserId={currentUserId}
  />,
  document.getElementById(targetIdAttr)
);
