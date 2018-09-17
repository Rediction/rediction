class Api::WordsController < Api::SecureApplicationController
  # 一回のアクセスで取得するレコードの数
  FETCH_COUNT = 30

  before_action :set_current_user_id

  # 最新順のWords一覧
  def index_latest_order
    @words = Word.fetch_latest_records(limit: FETCH_COUNT, max_fetched_id: params[:last_fetched_word_id])

    set_favorite_word_ids(@words, params[:current_user_id])
  end

  # ランダム並んだWords一覧
  # RESTなやり取りで、ランダムな無限スクロールに対応するため、以下のような処理で対応している。
  # 負荷が高くなりやすいので、メソッドの改修または、レコメンドなど事前にスコアを振り、その順に取得する方針を検討した方がいい。
  #
  # 処理内容
  # 呼び出し元からは常にユニークなトークンを送信してもらっている。(最初の一回のみは空、2回目以降は1回目のアクセスで生成したトークン)
  # 毎回ランダム取得したWordのIDをそのトークンに紐づけてword_random_fetched_recordsテーブルに登録して、
  # 2度目以降のアクセスで紐づけたトークンを再度送信してもらうことで、
  # トークンとまだ紐づいていない(まだ取得していない)wordsの中からランダムで取得する処理を実現している。
  def index_random_order
    # トークンを取得 or 生成
    @random_fetched_token = Word::RandomFetchedToken.first_or_create_unique_token(params[:token])

    # まだ取得していないwordsをランダム取得
    @words = Word.fetch_random_by_fetched_token(token: @random_fetched_token.token, limit: FETCH_COUNT)

    # 取得したwordsをトークンに紐づけて登録
    Word::RandomFetchedRecord.bulk_insert_by_words_and_token_id(token_id: @random_fetched_token.id, words: @words)

    set_favorite_word_ids(@words, params[:current_user_id])
  end

  # お気に入り登録されたWords一覧
  def index_scoped_favorite_words
    @words = Word.fetch_favorites_records(
      limit: FETCH_COUNT,
      max_fetched_id: params[:last_fetched_favorite_id],
      user_id: params[:target_user_id],
    )

    set_favorite_word_ids(@words, params[:current_user_id])
  end

  # フォローしたユーザーのWords一覧
  def index_scoped_follow_users
    @words = Word.fetch_latest_records(limit: FETCH_COUNT, max_fetched_id: params[:last_fetched_word_id])
                 .includes(user: :followed_relations)
                 .where(user_follow_relations: {following_user_id: params[:current_user_id]})

    set_favorite_word_ids(@words, params[:current_user_id])
  end

  # ログイン中のユーザーのWords一覧
  def index_scoped_user
    @words = Word.fetch_latest_records(limit: FETCH_COUNT, max_fetched_id: params[:last_fetched_word_id])
                 .where(user_id: params[:target_user_id])

    set_favorite_word_ids(@words, params[:current_user_id])
  end

  # 検索結果一覧
  def search
    @words = Word.fetch_latest_records(limit: FETCH_COUNT, max_fetched_id: params[:last_fetched_word_id])

    # 検索条件を追加
    @words = @words.where("name LIKE ?", "%#{params[:search_word]}%")
                   .or(@words.where("phonetic LIKE ?", "%#{params[:search_word]}%"))

    set_favorite_word_ids(@words, params[:current_user_id])
  end

  private

  # TODO (Shokei Takanashi)
  # 今後、JWTなどを利用したAPI用のcurrent_userを実装して、そのcurrent_userを利用するようにする。
  # 今の段階でsession[:user_id]を利用せずにわざわざクライアント側からuser_idを送るようにしているのは、
  # 将来的にAPI側とクライアント側を別APPにした時にも大きく回収する必要がないように、
  # 今のうちにRESTにしている。
  def set_current_user_id
    @current_user_id = params[:current_user_id].to_i
  end

  # お気に入り登録されているWordのID(配列)をインスタンス変数に格納
  def set_favorite_word_ids(words, user_id)
    @favorite_word_ids = Favorite.extract_favorite_word_ids(words: words, user_id: user_id)
  end
end
