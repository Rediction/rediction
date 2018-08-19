class Admin::WordsController < Admin::ApplicationController
  def index
    @words = ::Word.page(params[:page]).per(20).order(id: :desc)
  end

  def show
    @word = ::Word.find(params[:id])
  end

  def destroy
    word = ::Word.find(params[:id])
    word.destroy_with_changes!

    redirect_to admin_words_path, flash: { success: "言葉ID #{params[:id]}を削除しました。" }
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "削除に失敗しました。"
    redirect_to admin_word_path(id: params[:id])
  end
end
