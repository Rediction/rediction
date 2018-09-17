import BaseFetcher, { BaseFetcherInterface } from "./BaseFetcher";

interface FavoriteHandlerInterface extends BaseFetcherInterface {
  toggleFavoriteStatus(): Promise<boolean | null>;
}

class FavoriteHandler extends BaseFetcher implements FavoriteHandlerInterface {
  constructor(wordId: string, currentUserId: string) {
    super(`/words/${wordId}/users/${currentUserId}/favorite`);
  }

  // お気に入りステータスを更新(現状のステータスと反対のステータスに更新する)
  async toggleFavoriteStatus() {
    // リクエスト中の場合は、空配列を返却
    if (this.isRequesting()) {
      return null;
    }

    // リクエスト開始
    this.startRequest();

    // 言葉リストを取得
    const responseData = await this.patch();
    const favorited: boolean = responseData.favorited;

    // リクエスト終了
    this.endRequest();

    return favorited;
  }
}

export default FavoriteHandler;
