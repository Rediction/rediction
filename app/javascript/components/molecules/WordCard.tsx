import * as React from "react";
import FavoriteHandler from "../../providers/FavoriteHandler";
import FetchedWordInterface from "../../providers/Word/FetchedWordInterface";
import Card from "../atoms/Card";

interface Props {
  word: FetchedWordInterface;
  intervalSpace: string;
  userId: string;
}

interface State {
  word: FetchedWordInterface;
}

class WordCard extends React.Component<Props, State> {
  private favoriteHandler: FavoriteHandler = new FavoriteHandler(
    String(this.props.word.id),
    this.props.userId
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
    e.stopPropagation();
    e.preventDefault();

    const favoriteId:
      | number
      | boolean
      | null = await this.favoriteHandler.toggleFavoriteStatus();

    // falseが返された時は処理を中断
    if (favoriteId === false) {
      return;
    }

    this.setState({ word: { ...this.state.word, favorite_id: favoriteId } });
  }

  render() {
    const { intervalSpace } = this.props;
    const { word } = this.state;

    return (
      <Card link={`/words/${word.id}`}>
        <div
          style={{ ...styles.container, marginBottom: `${intervalSpace}px` }}
        >
          <h4>言葉</h4>
          <p>ID : {word.id}</p>
          <p>意味 : {word.name}</p>
          <p>フリガナ : {word.phonetic}</p>
          <p>定義 : {word.description}</p>

          <div onClick={e => this.navigateUserDetail(e)}>
            <h4>プロフィール</h4>
            <p>氏名 : {word.profile.first_name + word.profile.last_name}</p>
            <p>
              フリガナ :{" "}
              {word.profile.first_name_kana + word.profile.last_name_kana}
            </p>
            <p>生年月日 : {word.profile.birth_on}</p>
            <p>職業 : {word.profile.job}</p>
          </div>

          <i
            className={word.favorite_id ? "fas fa-star" : "far fa-star"}
            onClick={e => this.toggleFavoriteStatus(e)}
          />
        </div>
      </Card>
    );
  }
}

const styles = {
  container: {
    padding: "17px 22px 11px 10px"
  }
};

export default WordCard;
