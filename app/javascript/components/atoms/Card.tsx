import * as React from "react";

interface Props {
  link?: string;
  children: JSX.Element;
}

const Card: React.SFC<Props> = ({ link, children }) => {
  if (link) {
    return (
      <a href={link} style={styles.card}>
        {children}
      </a>
    );
  } else {
    return <div style={styles.card}>{children}</div>;
  }
};

const styles = {
  card: {
    display: "block",
    color: "inherit",
    textDecoration: "none",
    boxShadow: "0 0 10px #EDEDED",
    borderRadius: "6px"
  }
};

export default Card;
