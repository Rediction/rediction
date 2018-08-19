import BaseFetcher, { WordFetcherInterface } from "./../BaseFetcher";

class ScopedFollowUsersFetcher extends BaseFetcher
  implements WordFetcherInterface {
  // 取得した言葉のうち、最古のID
  private oldestFetchedId: number = 0;

  constructor() {
    // APIのパスを設定
    super("/words/index_scoped_follow_users");
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
    const parameter =
      this.oldestFetchedId !== 0
        ? `?last_fetched_word_id=${this.oldestFetchedId}`
        : "";

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

export default ScopedFollowUsersFetcher;
