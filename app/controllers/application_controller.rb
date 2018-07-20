class ApplicationController < ActionController::Base
  before_action :basic_authentication if ENV['BASIC_AUTH_USERNAME'].present? && ENV['BASIC_AUTH_PASSWORD'].present?
  private

    # Basic認証
    def basic_authentication
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
      end
    end
end
