class WordsController < ApplicationController
  # 最新順のWords一覧
  def index_latest_order
  end

  # ランダム並んだWords一覧
  def index_random_order
  end

  # フォローしたユーザーのWords一覧
  def index_scoped_follow_users
  end

  # 検索結果一覧
  def search
  end

  def new
    @word = current_user.words.build
  end

  def create
    @word = current_user.words.build(word_params)
    @word.save_with_changes!

    redirect_to user_mypage_path, flash: { success: "投稿しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error]  = "投稿に失敗しました。"
    render :new
  end

  def show
    @word = Word.find(params[:id])
  end

  def destroy
    word = current_user.words.find(params[:id])
    word.destroy_with_changes!

    redirect_to user_mypage_path, flash: { success: "削除しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = "削除に失敗しました。"
    redirect_to word_path(params[:id])
  end

  private

  def word_params
    params.require(:word).permit(:name, :phonetic, :description)
  end
end
