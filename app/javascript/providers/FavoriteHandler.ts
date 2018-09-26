import BaseFetcher, { BaseFetcherInterface } from "./BaseFetcher";

interface FavoriteHandlerInterface extends BaseFetcherInterface {
  toggleFavoriteStatus(): Promise<FavoriteHandlerResponse | null>;
}

export interface FavoriteHandlerResponse {
  favorited: boolean;
  favorite_count: number;
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

    // お気に入りステータスの更新
    const responseData: FavoriteHandlerResponse = await this.patch();

    // リクエスト終了
    this.endRequest();

    return responseData;
  }
}

export default FavoriteHandler;
