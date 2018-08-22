import $ from "jquery";
import * as React from "react";
import ReactDOM from "react-dom";
import UsersCardList from "../../../components/organisms/UsersCardList";

// User一覧を表示する対象のID
const targetIdAttr = "users-list";

// 表示中のページのユーザーのID
const userId = $(`#${targetIdAttr}`).data("user-id");

ReactDOM.render(
  <UsersCardList targetIdAttr={targetIdAttr} userId={userId} />,
  document.getElementById(targetIdAttr)
);
