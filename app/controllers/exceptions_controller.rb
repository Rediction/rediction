class ExceptionsController < ApplicationController
  include ExceptionHandlers

  # routingエラーがRack層で発生するもので、rescue_fromでは拾えないため、
  # ルーティングで明示的に本アクションに飛ばして対応
  # routing_error時の処理はExceptionHandlerに記述
end
