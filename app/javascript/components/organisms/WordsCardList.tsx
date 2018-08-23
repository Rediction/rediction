import * as React from "react";
import { WordFetcherInterface } from "../../providers/BaseFetcher";
import ScrollHandler from "../../providers/ScrollHandler";
import FetchedWordInterface from "../../providers/Word/FetchedWordInterface";
import ActivityIndicator from "../atoms/ActivityIndicator";
import WordCard from "../molecules/WordCard";

interface Props {
  targetIdAttr: string; // 一覧を表示する対象のID
  wordFethcer: WordFetcherInterface;
  userId: string;
}

interface State {
  words: FetchedWordInterface[];
  loading: boolean;
}

class WordsCardList extends React.Component<Props, State> {
  private scrollHandler: ScrollHandler = new ScrollHandler();

  constructor(props: Props) {
    super(props);

    this.state = { words: [], loading: true };

    this.refetchWords = this.refetchWords.bind(this);
  }

  componentDidMount() {
    const { targetIdAttr } = this.props;

    this.fetchWords();

    // 無限スクロール用のイベントを設定
    this.scrollHandler.setActionWhenBottomOfElm(
      targetIdAttr,
      this.refetchWords
    );
  }

  handleWords(words: FetchedWordInterface[]) {
    this.setState({ words: this.state.words.concat(words) });
  }

  handleLoading(loading: boolean) {
    this.setState({ loading });
  }

  // 言葉を取得
  async fetchWords() {
    const { wordFethcer } = this.props;
    const words: FetchedWordInterface[] = await wordFethcer.fetchWords();

    this.handleWords(words);
    this.handleLoading(false);
  }

  // 言葉を再度取得
  refetchWords() {
    this.handleLoading(true);
    this.fetchWords();
  }

  render() {
    const { userId } = this.props;
    const { words, loading } = this.state;

    if (loading && words.length === 0) {
      return (
        <div style={styles.container}>
          <ActivityIndicator size="small" />
        </div>
      );
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

export default WordsCardList;
