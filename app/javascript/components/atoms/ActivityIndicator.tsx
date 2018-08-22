import * as React from "react";

interface Props {
  size: "small" | "middle" | "large";
}

const ActivityIndicator: React.SFC<Props> = ({ size }) => {
  const width: string =
    size === "small" ? "25" : size === "middle" ? "32" : "48";

  return (
    <div style={{ textAlign: "center" }}>
      <img
        src={require("../../images/gif/activeIndicator.gif")}
        width={width}
      />
    </div>
  );
};

export default ActivityIndicator;
