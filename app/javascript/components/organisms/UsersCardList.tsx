import * as React from "react";
import FollowedUserFetcher, { FollowedUser } from "../../providers/FollowedUserFetcher";
import ScrollHandler from "../../providers/ScrollHandler";
import ActivityIndicator from "../atoms/ActivityIndicator";
import UserCard from "../molecules/UserCard";

interface Props {
  targetIdAttr: string; // 一覧を表示する対象のID
  userId: string;
}

interface State {
  users: any;
  loading: boolean;
}

class UsersCardList extends React.Component<Props, State> {
  private followedUserFetcher: FollowedUserFetcher = new FollowedUserFetcher(
    this.props.userId
  );
  private scrollHandler: ScrollHandler = new ScrollHandler();

  constructor(props: Props) {
    super(props);

    this.state = { users: [], loading: true };

    this.refetchUsers = this.refetchUsers.bind(this);
  }

  componentDidMount() {
    const { targetIdAttr } = this.props;

    this.fetchUsers();

    // 無限スクロール用のイベントを設定
    this.scrollHandler.setActionWhenBottomOfElm(
      targetIdAttr,
      this.refetchUsers
    );
  }

  handleUsers(users: FollowedUser[]) {
    this.setState({ users: this.state.users.concat(users) });
  }

  handleLoading(loading: boolean) {
    this.setState({ loading });
  }

  // ユーザーを取得
  async fetchUsers() {
    const users: FollowedUser[] = await this.followedUserFetcher.fetchUsers();

    this.handleUsers(users);
    this.handleLoading(false);
  }

  // ユーザーを再度取得
  refetchUsers() {
    this.handleLoading(true);
    this.fetchUsers();
  }

  render() {
    const { users, loading } = this.state;

    if (loading && users.length === 0) {
      return <ActivityIndicator size="middle" />;
    }

    return (
      <div style={styles.container}>
        {users.map((user: FollowedUser) => (
          <UserCard key={user.id} user={user} intervalSpace="13" />
        ))}
        {loading ? <ActivityIndicator size="middle" /> : null}
      </div>
    );
  }
}

const styles = {
  container: {
    margin: "0 18px"
  }
};

export default UsersCardList;
