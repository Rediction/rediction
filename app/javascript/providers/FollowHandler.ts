import BaseFetcher, { BaseFetcherInterface } from "./BaseFetcher";

interface FollowHandlerInterface extends BaseFetcherInterface {
  toggleFollowStatus(): Promise<number | false | null>;
}

class FollowHandler extends BaseFetcher implements FollowHandlerInterface {
  constructor(followingUserId: string, followedUserId: string) {
    super(
      `/user/follow_relation?following_user_id=${followingUserId}&followed_user_id=${followedUserId}`
    );
  }

  // お気に入りステータスを更新(現状のステータスと反対のステータスに更新する)
  async toggleFollowStatus() {
    // リクエスト中の場合は、空配列を返却
    if (this.isRequesting()) {
      return false;
    }

    // リクエスト開始
    this.startRequest();

    // 言葉リストを取得
    const responseData = await this.patch();
    const followId: number | false = responseData.follow_id;

    // リクエスト終了
    this.endRequest();

    return followId;
  }
}

export default FollowHandler;
