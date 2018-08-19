import * as React from "react";

interface Props {
  size: "small" | "middle" | "large";
}

const ActivityIndicator: React.SFC<Props> = ({ size }) => {
  const width: string =
    size === "small" ? "30" : size === "middle" ? "60" : "90";

  return (
    <img src={require("../../images/gif/activeIndicator.gif")} width={width} />
  );
};

export default ActivityIndicator;
