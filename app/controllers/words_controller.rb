class WordsController < ApplicationController
  def index
    @words = Word.order("id DESC")
  end

  def new
    @word = current_user.words.build
  end

  def create
    @word = current_user.words.build(word_params)
    @word.save_with_changes!
    redirect_to words_path, flash: { success: "投稿しました。" }
  rescue ActiveRecord::RecordInvalid
    flash.now[:error]  = "投稿に失敗しました。"
    render :new
  end

  def destroy
    word = current_user.words.find(params[:id])
    word.destroy_with_changes!
    redirect_to words_path, flash: { success: "削除しました。" }
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "削除に失敗しました。"
    redirect_to words_path
  end

  private

  def word_params
    params.require(:word).permit(:name, :phonetic, :description)
  end
end
