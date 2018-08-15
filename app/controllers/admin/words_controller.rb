class Admin::WordsController < Admin::ApplicationController
  def index
    # TODO(Shokei Takanashi) : wordsテーブルを作成したタイミングでコメントアウトを外して実装する。
    # words = Word.page(params[:page]).per(20).order(id: :desc)
  end

  def show
    # TODO(Shokei Takanashi) : wordsテーブルを作成したタイミングでコメントアウトを外して実装する。
    # word = Word.find(params[:id])
  end
end
