class WordsController < ApplicationController

  def index
    @words = Word.order("id DESC")
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(word_params)
    @word.save_with_changes!
    redirect_to words_path, flash: { success: "投稿しました。" }
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "投稿に失敗しました。"
    render :new
  end

  def destroy
    word = Word.find(params[:id])
    word.destroy_with_changes!
    redirect_to words_path, flash: { success: "削除しました。" }
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "削除に失敗しました。"
    redirect_to words_path
  end

  private

  def word_params
    params.require(:word).permit(:name, :phonetic, :description, :user_id)
  end
end
