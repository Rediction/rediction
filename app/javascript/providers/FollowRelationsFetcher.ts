import BaseFetcher, { BaseFetcherInterface } from "./BaseFetcher";

export interface FollowRelation {
  id: number;
  user: User;
  profile: Profile;
  latest_word_ja_created_at: string;
}

interface User {
  id: number;
  email: string;
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
  age: number;
}

interface FollowRelationsFetcherInterface extends BaseFetcherInterface {
  fetchFollowRelations(): Promise<FollowRelation[]>;
}

class FollowRelationsFetcher extends BaseFetcher
  implements FollowRelationsFetcherInterface {
  // 取得した言葉のうち、最古のID
  private oldestFetchedId: number = 0;

  constructor(targetUserId: string) {
    // APIのパスを設定
    super(`/users/${targetUserId}/follow_relations`);
  }

  // 言葉を取得
  async fetchFollowRelations() {
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
    const { follow_relations: followRelations } = await this.fetch(parameter);

    // 言葉を１つ以上取得できた場合は、最古のIDを更新
    if (followRelations.length > 0) {
      this.oldestFetchedId = followRelations[followRelations.length - 1].id;
    }

    // リクエスト終了
    this.endRequest();

    return followRelations;
  }
}

export default FollowRelationsFetcher;
