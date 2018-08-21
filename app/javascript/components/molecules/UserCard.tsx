import * as React from "react";
import Card from "../atoms/Card";
import { FollowedUser } from "../../providers/FollowedUserFetcher";

interface Props {
  user: FollowedUser;
  intervalSpace: string;
}

const UserCard: React.SFC<Props> = ({ user, intervalSpace }) => {
  return (
    <Card link={`/users/${user.id}`}>
      <div style={{ ...styles.container, marginBottom: `${intervalSpace}px` }}>
        <h4>言葉</h4>
        <p>ID : {user.id}</p>
        <p>名前 : {user.profile.first_name + user.profile.last_name}</p>
        <p>職業 : {user.profile.job}</p>
      </div>
    </Card>
  );
};

const styles = {
  container: {
    padding: "17px 22px 11px 10px"
  }
};

export default UserCard;
