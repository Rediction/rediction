import $ from "jquery";
import * as React from "react";
import ScrollHandler from "../../providers/ScrollHandler";
import FetchedWordInterface from "../../providers/Word/FetchedWordInterface";
import WordSearchFetcher from "../../providers/Word/SearchFetcher";
import ActivityIndicator from "../atoms/ActivityIndicator";
import WordCard from "../molecules/WordCard";

interface Props {
  targetIdAttr: string; // 一覧を表示する対象のID
  searchFieldIdAttr: string; // 検索用の入力フォームのID
  searchBtnIdAttr: string; // 検索用のボタンのID
  userId: string;
}

interface State {
  words: FetchedWordInterface[];
  loading: boolean;
  searchWord: string;
}

class SearchedWordsCardList extends React.Component<Props, State> {
  private wordSearchFetcher: WordSearchFetcher = new WordSearchFetcher(
    this.props.userId
  );
  private scrollHandler: ScrollHandler = new ScrollHandler();

  constructor(props: Props) {
    super(props);

    this.state = { words: [], loading: false, searchWord: "" };

    this.searchWords = this.searchWords.bind(this);
    this.researchWords = this.researchWords.bind(this);
  }

  resetWords() {
    this.setState({ words: [] });
  }

  handleWords(words: FetchedWordInterface[]) {
    this.setState({ words: this.state.words.concat(words) });
  }

  handleLoading(loading: boolean) {
    this.setState({ loading });
  }

  componentDidMount() {
    const { targetIdAttr, searchFieldIdAttr, searchBtnIdAttr } = this.props;

    // TODO(Shokei Takanashi)
    // 現状、ページ全体をReact.jsにしているわけではないないので、検索フォームの部品をstateで扱うことができないため、
    // イベントをつけて、無理やりstateを更新するようにしている。
    // 今後、ページ全体をReact.jsで実装していく際に、検索フォームの内容もstate管理するように改修する。
    $(`#${searchFieldIdAttr}`).on("keyup", e => {
      const searchWord: string = $(e.target).val() as string;
      this.setState({ searchWord });
    });
    $(`#${searchBtnIdAttr}`).on("click", this.searchWords);

    // 無限スクロール用のイベントを設定
    this.scrollHandler.setActionWhenBottomOfElm(
      targetIdAttr,
      this.researchWords
    );
  }

  // 言葉を取得
  async searchWords() {
    const { searchWord } = this.state;
    this.handleLoading(true);

    this.resetWords();
    const words: FetchedWordInterface[] = await this.wordSearchFetcher.searchWords(
      searchWord
    );

    this.handleWords(words);
    this.handleLoading(false);
  }

  // 言葉を再度取得
  async researchWords() {
    this.handleLoading(true);

    const words: FetchedWordInterface[] = await this.wordSearchFetcher.searchWords();
    this.handleWords(words);

    this.handleLoading(false);
  }

  render() {
    const { userId } = this.props;
    const { words, loading } = this.state;

    if (loading && words.length === 0) {
      return <ActivityIndicator size="middle" />;
    }

    return (
      <div style={styles.container}>
        {words.map((word: FetchedWordInterface) => (
          <WordCard
            key={word.id}
            word={word}
            userId={userId}
            intervalSpace="13"
          />
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

export default SearchedWordsCardList;
