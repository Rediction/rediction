# _changes用のModule
# originalのレコードを元に履歴を生成するメソッドを付加するModule
# includeする_changesテーブル用のModelには必ずORIGINAL_FOREIGN_KEYを定義して、FKをシンボルで格納すること。
module CreatableFromOriginal
  extend ActiveSupport::Concern

  CHANGES_EVENT_TYPES = ['create', 'update', 'delete']

  included do
    validates :event, presence: true, inclusion: { in: CHANGES_EVENT_TYPES }
  end

  module ClassMethods
    # Originalのレコードを元に変更履歴を生成
    # @param  [ApplicationRecord] original_record
    # @param  [String] event
    # @return [ApplicationRecord]
    def create_from_original!(original_record:, event:)
      create!(
        original_record.attributes
                .except("id", "created_at", "updated_at")
                .merge(self::ORIGINAL_FOREIGN_KEY => original_record.id, event: event)
      )
    end
  end
end
