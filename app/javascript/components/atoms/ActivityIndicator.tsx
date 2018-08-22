import * as React from "react";

interface Props {
  size: "small" | "middle" | "large";
  alignCenter?: boolean;
}

const ActivityIndicator: React.SFC<Props> = ({ size, alignCenter }) => {
  const width: string =
    size === "small" ? "30" : size === "middle" ? "60" : "90";

  const styles = alignCenter ? { textAlign: "center" } : {};

  return (
    <div style={styles}>
      <img
        src={require("../../images/gif/activeIndicator.gif")}
        width={width}
      />
    </div>
  );
};

export default ActivityIndicator;
