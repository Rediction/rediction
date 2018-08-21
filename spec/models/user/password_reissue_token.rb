require "rails_helper"

RSpec.describe User::PasswordReissueToken, type: :model do
  include_context 'Changesテーブルを有する場合', PasswordReissueToken
end
