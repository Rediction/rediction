# TODO(Shokei Takanashi) : ひとまず簡易的に実装しただけなので、ログのフォーマットや項目踏まえて、今後考え直して改修する。
module ExceptionHandlers
  extend ActiveSupport::Concern

  class Forbidden < StandardError; end # 403
  class NotFound < StandardError; end # 404
  class ServiceUnavailable < StandardError; end # 503
  class InternalServerError < StandardError; end # 500

  included do
    rescue_from ExceptionHandlers::Forbidden, with: :forbidden # 403
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found # 404
    rescue_from ExceptionHandlers::NotFound, with: :not_cound # 404
    rescue_from ExceptionHandlers::InternalServerError, with: :internal_server_error # 500
    rescue_from ExceptionHandlers::ServiceUnavailable, with: :service_unavailable # 503
  end

  # routingエラーがRack層で発生するもので、rescue_fromでは拾えないため、
  # exceptions_controller経由で対応
  def routing_error
    write_log "routing_error", Time.current
    render_exception 404
  end

  private

  # 403
  def forbidden(e = nil)
    write_log "forbidden", e
    render_exception 403
  end

  # 404
  def record_not_found(e = nil)
    write_log "record_not_found", e
    render_exception 404
  end

  # 404
  def not_cound(e = nil)
    write_log "not_found", e
    render_exception 404
  end

  # 500
  def internal_server_error(e = nil)
    write_log "internal_server_error", e
    render_exception 500
  end

  # 503
  def service_unavailable(e = nil)
    write_log "service_unavailable", e
    render_exception 503
  end

  def write_log(title, e = nil)
    msg = "エラーメッセージはなし"
    msg = e.try(:message) if e.try(:message).present?

    logger.info "#{title}: #{msg}"
  end

  def render_exception(status_code)
    render template: "exceptions/#{status_code}",
           status: status_code,
           layout: "application",
           content_type: "text/html"
  end
end
