import BaseFetcher from "./../BaseFetcher";
import FetchedWordInterface from "./FetchedWordInterface";

// 継承先のWord取得処理を責務とするクラスのInterface
export interface WordsSearchFetcherInterface {
  setSearchWord(searchWord: string): any;
  resetOldestFetchedId(): any;
  searchWords(searchWord?: string): Promise<FetchedWordInterface[]>;
}

class WordsSearchFetcher extends BaseFetcher
  implements WordsSearchFetcherInterface {
  // 取得した言葉のうち、最古のID
  private oldestFetchedId: number = 0;
  private searchWord: string = "";

  constructor() {
    // APIのパスを設定
    super("/words/search");
  }

  setSearchWord(searchWord: string) {
    this.searchWord = searchWord;
  }

  resetOldestFetchedId() {
    this.oldestFetchedId = 0;
  }

  // 言葉を取得
  // 2回目以降の検索では、引数を空にすること。
  // 引数を与えると、検索ワードが更新され、それまで取得したIDもリセットされる。
  async searchWords(searchWord?: string) {
    // リクエスト中の場合は、空配列を返却
    // また、検索ワードがない場合も配列を返却
    if (this.isRequesting() || (!searchWord && !this.searchWord)) {
      return [];
    }

    // リクエスト開始
    this.startRequest();

    // 引数に検索ワードが入っていれば、検索ワードを更新
    if (searchWord) {
      this.setSearchWord(searchWord);
      this.resetOldestFetchedId();
    }

    // 取得した最古の言葉IDが格納済みの場合は、パラメータとして設定
    const parameter: string =
      `?search_word=${this.searchWord}` +
      (this.oldestFetchedId !== 0
        ? `&last_fetched_word_id=${this.oldestFetchedId}`
        : "");

    // 言葉リストを取得
    const { words } = await this.fetch(parameter);

    // 言葉を１つ以上取得できた場合は、最古のIDを更新
    if (words.length > 0) {
      this.oldestFetchedId = words.pop().id;
    }

    // リクエスト終了
    this.endRequest();

    return words;
  }
}

export default WordsSearchFetcher;
