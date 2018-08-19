import * as React from "react";
import Card from "../atoms/Card";

interface Props {
  user: any;
}

const UserCard: React.SFC<Props> = ({ user }) => {
  return (
    <Card>
      <div>
        <p>準備中</p>
        <p>{user}</p>
      </div>
    </Card>
  );
};

export default UserCard;
