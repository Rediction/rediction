import * as React from "react";

interface Props {
  children: JSX.Element;
}

const Card: React.SFC<Props> = ({ children }) => {
  return <div style={styles.card}>{children}</div>;
};

const styles = {
  card: {
    boxShadow: "0 0 10px #EDEDED",
    borderRadius: "6px"
  }
};

export default Card;
