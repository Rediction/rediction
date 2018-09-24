import $ from "jquery";
import * as React from "react";
import ReactDOM from "react-dom";
import UsersCardList from "../../../components/organisms/UsersCardList";

// User一覧を表示する対象のID
const targetIdAttr = "users-list";

// 表示中のページのユーザーのID
const targetUserId = $(`#${targetIdAttr}`).data("target-user-id");

ReactDOM.render(
  <UsersCardList targetIdAttr={targetIdAttr} targetUserId={targetUserId} />,
  document.getElementById(targetIdAttr)
);
