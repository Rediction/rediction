class ApplicationController < ActionController::Base
  before_action :basic_authentication

  private

    # Basic認証
    def basic_authentication
      authenticate_or_request_with_http_basic do |username, password|
        username == 'rediction' && password == 'dictionary'
      end
    end
end
