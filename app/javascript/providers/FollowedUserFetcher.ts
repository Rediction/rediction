import BaseFetcher, { BaseFetcherInterface } from "./BaseFetcher";

export interface FollowedUser {
  id: number;
  email: string;
  profile: Profile;
}

interface Profile {
  id: number;
  user_id: number;
  last_name: string;
  last_name_kana: string;
  first_name: string;
  first_name_kana: string;
  birth_on: string;
  job: string;
}

interface FollowedUserFetcherrInterface extends BaseFetcherInterface {
  fetchUsers(): Promise<FollowedUser[]>;
}

class FollowedUserFetcher extends BaseFetcher
  implements FollowedUserFetcherrInterface {
  // 取得した言葉のうち、最古のID
  private oldestFetchedId: number = 0;

  constructor(userId: string) {
    // APIのパスを設定
    super(`/users/${userId}/follow_relations`);
  }

  // 言葉を取得
  async fetchUsers() {
    // リクエスト中の場合は、空配列を返却
    if (this.isRequesting()) {
      return [];
    }

    // リクエスト開始
    this.startRequest();

    // 取得した最古の言葉IDが格納済みの場合は、パラメータとして設定
    const parameter =
      this.oldestFetchedId !== 0
        ? `?last_fetched_id=${this.oldestFetchedId}`
        : "";

    // 言葉リストを取得
    const { users } = await this.fetch(parameter);

    // 言葉を１つ以上取得できた場合は、最古のIDを更新
    if (users.length > 0) {
      this.oldestFetchedId = users[users.length - 1].id;
    }

    // リクエスト終了
    this.endRequest();

    return users;
  }
}

export default FollowedUserFetcher;
