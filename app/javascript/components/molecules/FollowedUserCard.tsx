import * as React from "react";
import { FollowRelation } from "../../providers/FollowRelationsFetcher";
import Card from "../atoms/Card";

interface Props {
  followRelation: FollowRelation;
  intervalSpace: string;
}

const FollowedUserCard: React.SFC<Props> = ({
  followRelation,
  intervalSpace
}) => {
  return (
    <Card link={`/users/${followRelation.user.id}`}>
      <div style={{ ...styles.container, marginBottom: `${intervalSpace}px` }}>
        <h3 style={styles.userCardFullName}>
          {followRelation.profile.last_name + followRelation.profile.first_name}
        </h3>
        <p style={styles.userCardSubText}>
          職業 : {followRelation.profile.job}
        </p>
        <p style={styles.userCardSubText}>
          年齢 : {followRelation.profile.age}歳
        </p>
        <p style={styles.userCardSubText}>
          最新投稿日 : {followRelation.latest_word_ja_created_at}
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

export default FollowedUserCard;
