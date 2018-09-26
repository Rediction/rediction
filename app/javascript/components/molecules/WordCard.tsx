import * as React from "react";
import FavoriteHandler, {
  FavoriteHandlerResponse
} from "../../providers/FavoriteHandler";
import NumberFormatter from "../../providers/Formatter/NumberFormatter";
import FetchedWordInterface from "../../providers/Word/FetchedWordInterface";
import Color from "../../styles/Color";
import Card from "../atoms/Card";

interface Props {
  word: FetchedWordInterface;
  intervalSpace: string;
  currentUserId: string;
}

interface State {
  word: FetchedWordInterface;
}

class WordCard extends React.Component<Props, State> {
  private favoriteHandler: FavoriteHandler = new FavoriteHandler(
    String(this.props.word.id),
    this.props.currentUserId
  );

  constructor(props: Props) {
    super(props);

    // お気に入りステータスの更新などがあるので、wordはstate管理する。
    const { word } = this.props;

    this.state = { word };
  }

  // ユーザー詳細に遷移する処理
  navigateUserDetail(e: any) {
    e.stopPropagation();
    e.preventDefault();

    const { word } = this.state;
    location.href = `/users/${word.user_id}`;
  }

  // お気に入りステータスを更新(現状のステータスと反対のステータスに更新する)
  async toggleFavoriteStatus(e: any) {
    // リンクによるページ遷移を停止
    e.stopPropagation();
    e.preventDefault();

    // API通信が完了する前に見た目上だけ切り替える。
    this.advanceUpdateForToggleFavoriteStatus();

    const favoriteHandlerResponse: FavoriteHandlerResponse | null = await this.favoriteHandler.toggleFavoriteStatus();

    // nullが返された時は処理を中断
    if (favoriteHandlerResponse === null) {
      return;
    }

    const { favorited, favorite_count } = favoriteHandlerResponse;
    this.setState({ word: { ...this.state.word, favorited, favorite_count } });
  }

  // お気に入りステータスの切り替え用の事前更新処理
  advanceUpdateForToggleFavoriteStatus() {
    const { word } = this.state;
    const { favorited, favorite_count: favoriteCount } = word;

    // お気に入り済みの場合は現状のお気に入り件数 - 1、お気に入り未登録の場合は現状のお気に入り件数 + 1の件数を格納
    const advanceFavoriteCount: number = favorited
      ? favoriteCount - 1
      : favoriteCount + 1;

    this.setState({
      word: {
        ...word,
        favorited: !favorited,
        favorite_count: advanceFavoriteCount
      }
    });
  }

  render() {
    const { intervalSpace } = this.props;
    const { word } = this.state;

    return (
      <Card link={`/words/${word.id}`}>
        <div
          style={{ ...styles.container, marginBottom: `${intervalSpace}px` }}
        >
          <h3 style={{ ...styles.wordName, fontWeight: "bold" }}>
            {word.name} [{word.phonetic}]
          </h3>
          <p style={{ ...styles.wordDescription, whiteSpace: "pre-wrap" }}>
            {word.description}
          </p>

          <div style={styles.footer}>
            <p style={styles.profile} onClick={e => this.navigateUserDetail(e)}>
              {word.profile.last_name + word.profile.first_name}/
              {word.profile.job}
            </p>

            <div style={styles.favoriteFrame}>
              <img
                style={styles.favoriteIcon}
                src={
                  word.favorited
                    ? require("../../images/favorite/favoriteIcon.svg")
                    : require("../../images/favorite/unfavoriteIcon.svg")
                }
                onClick={e => this.toggleFavoriteStatus(e)}
              />

              <p style={styles.favoriteCount}>
                {word.favorite_count !== 0
                  ? NumberFormatter.separateByComma(word.favorite_count)
                  : ""}
              </p>
            </div>
          </div>
        </div>
      </Card>
    );
  }
}

const styles = {
  container: {
    padding: "17px 22px 11px 10px"
  },
  wordName: {
    fontSize: "15px",
    marginBottom: "12px"
  },
  wordDescription: {
    fontSize: "14px",
    lineHeight: "24px"
  },
  footer: {
    marginTop: "9px",
    paddingTop: "13px",
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between",
    borderTop: `1px solid ${Color.Elm.Card.FOOTER_BORDER_GRAY}`
  },
  profile: {
    height: "100%",
    fontSize: "9px",
    color: Color.Elm.Card.THIN_GRAY
  },
  favoriteFrame: {
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between"
  },
  favoriteIcon: {
    width: "19px",
    color: Color.Site.SECONDARY
  },
  favoriteCount: {
    textAlign: "right" as "right",
    fontSize: "11px",
    width: "28px",
    color: Color.Site.SECONDARY
  }
};

export default WordCard;
