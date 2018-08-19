import BaseFetcher, { WordFetcherInterface } from "./../BaseFetcher";

class WordsOrderRandomFetcher extends BaseFetcher
  implements WordFetcherInterface {
  private token: string = "";

  constructor() {
    // APIのパスを設定
    super("/words/index_random_order");
  }

  // 言葉を取得
  async fetchWords() {
    // リクエスト中の場合は、空配列を返却
    if (this.isRequesting()) {
      return [];
    }

    // リクエスト開始
    this.startRequest();

    // 取得した最古の言葉IDが格納済みの場合は、パラメータとして設定
    const parameter = this.token ? `?token=${this.token}` : "";

    // 言葉リストを取得
    const { words, token } = await this.fetch(parameter);

    if (!this.token) {
      // 生成したトークンを設定
      this.token = token;
    }

    // リクエスト終了
    this.endRequest();

    return words;
  }
}

export default WordsOrderRandomFetcher;
