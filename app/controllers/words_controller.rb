class WordsController < ApplicationController

  def new
  end

  def create
    word = Word.new(word_params)
    if word.save
      flash[:success] = "投稿しました"
      redirect_to timelines_path
    else
      flash[:error] = "投稿に失敗しました"
      redirect_to new_word_path
    end
  end

  def destroy
    word = Word.find(params[:id])
    if word.destroy
      flash[:success] = "削除しました"
      redirect_to timelines_path
    else
      flash[:error] = "削除に失敗しました"
      redirect_to timelines_path
    end
  end

  private

  def word_params
    params.require(:word).permit(:name, :phonetic, :description, :user_id)
  end
end
