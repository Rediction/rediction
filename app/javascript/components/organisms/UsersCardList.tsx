import * as React from "react";
import FollowRelationsFetcher, {
  FollowRelation
} from "../../providers/FollowRelationsFetcher";
import ScrollHandler from "../../providers/ScrollHandler";
import ActivityIndicator from "../atoms/ActivityIndicator";
import FollowedUserCard from "../molecules/FollowedUserCard";

interface Props {
  targetIdAttr: string; // 一覧を表示する対象のID
  targetUserId: string;
}

interface State {
  followRelations: FollowRelation[];
  loading: boolean;
}

class UsersCardList extends React.Component<Props, State> {
  private followRelationsFetcher: FollowRelationsFetcher = new FollowRelationsFetcher(
    this.props.targetUserId
  );
  private scrollHandler: ScrollHandler = new ScrollHandler();

  constructor(props: Props) {
    super(props);

    this.state = { followRelations: [], loading: true };

    this.refetchFollowRelations = this.refetchFollowRelations.bind(this);
  }

  componentDidMount() {
    const { targetIdAttr } = this.props;

    this.fetchFollowRelations();

    // 無限スクロール用のイベントを設定
    this.scrollHandler.setActionWhenBottomOfElm(
      targetIdAttr,
      this.refetchFollowRelations
    );
  }

  handleFollowRelations(followRelations: FollowRelation[]) {
    this.setState({
      followRelations: this.state.followRelations.concat(followRelations)
    });
  }

  handleLoading(loading: boolean) {
    this.setState({ loading });
  }

  // ユーザーを取得
  async fetchFollowRelations() {
    const followRelations: FollowRelation[] = await this.followRelationsFetcher.fetchFollowRelations();

    this.handleFollowRelations(followRelations);
    this.handleLoading(false);
  }

  // ユーザーを再度取得
  refetchFollowRelations() {
    this.handleLoading(true);
    this.fetchFollowRelations();
  }

  render() {
    const { followRelations, loading } = this.state;

    if (loading && followRelations.length === 0) {
      return (
        <div style={styles.container}>
          <ActivityIndicator size="small" />
        </div>
      );
    }

    return (
      <div style={styles.container}>
        {followRelations.map((followRelation: FollowRelation) => (
          <FollowedUserCard
            key={followRelation.id}
            followRelation={followRelation}
            intervalSpace="13"
          />
        ))}
        {loading ? <ActivityIndicator size="small" /> : null}
      </div>
    );
  }
}

const styles = {
  container: {
    margin: "21px 0"
  }
};

export default UsersCardList;
