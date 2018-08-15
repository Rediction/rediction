require "rails_helper"

RSpec.describe Word, type: :model do
  include_context 'Changesテーブルを有する場合', Word
end
