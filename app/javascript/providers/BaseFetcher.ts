import ApiClient from "../providers/ApiClient";
import FetchedWordInterface from "./Word/FetchedWordInterface";

interface BaseFetcherInterface {
  isRequesting(): boolean;
  startRequest(): any;
  endRequest(): any;
  fetch(
    parameter: string
  ): Promise<{ words: FetchedWordInterface[]; token?: string }>;
}

// 継承先のWord取得処理を責務とするクラスのInterface
export interface WordFetcherInterface extends BaseFetcherInterface {
  fetchWords(): Promise<FetchedWordInterface[]>;
}

class BaseFetcher implements BaseFetcherInterface {
  private apiPath: string;
  private requesting: boolean = false;

  constructor(apiPath: string) {
    this.apiPath = apiPath;
  }

  isRequesting() {
    return this.requesting;
  }

  // リクエストフラグをTrueに更新
  startRequest() {
    this.requesting = true;
  }

  // リクエストフラグをFalseに更新
  endRequest() {
    this.requesting = false;
  }

  // APIを利用してデータを取得
  async fetch(parameter: string = "") {
    try {
      const response = await ApiClient.get(this.apiPath + parameter);
      return response.data;
    } catch (e) {
      throw e;
    }
    return {};
  }
}

export default BaseFetcher;
