import * as React from "react";
import { FollowedUser } from "../../providers/FollowedUserFetcher";
import Card from "../atoms/Card";

interface Props {
  user: FollowedUser;
  intervalSpace: string;
}

const UserCard: React.SFC<Props> = ({ user, intervalSpace }) => {
  return (
    <Card link={`/users/${user.id}`}>
      <div style={{ ...styles.container, marginBottom: `${intervalSpace}px` }}>
        <h3 style={styles.userCardFullName}>
          {user.profile.last_name + user.profile.first_name}
        </h3>
        <p style={styles.userCardSubText}>職業 : {user.profile.job}</p>
        <p style={styles.userCardSubText}>年齢 : {user.profile.age}歳</p>
        <p style={styles.userCardSubText}>
          最新投稿日 : {user.latest_word_ja_created_at}
        </p>
      </div>
    </Card>
  );
};

const styles = {
  container: {
    padding: "17px 22px 11px 10px"
  },
  userCardFullName: {
    fontSize: "18px",
    marginBottom: "12px"
  },
  userCardSubText: {
    fontSize: "14px",
    lineHeight: "24px"
  }
};

export default UserCard;
