# Changesテーブルを有するOriginalテーブル用のModule
# 登録・更新・削除処理それぞれにchangesテーブルの保存処理を付加したメソッドが定義されている。
# Changesテーブルを有するテーブルは原則として本Moduleに定義されているメソッドを使う必要がある。
#
# テスト(RSpec)について
# 本テストをIncludeしたクラスのテストには必ず~/spec/support/performable_with_changes_manager.rbの
# shared_contextをincludeすること。
# performable_with_changes_manager.rbの方に本モジュールのテストが全て記載されているため、
# 個別にテストを追記していく必要はない。
module PerformableWithChanges
  extend ActiveSupport::Concern

  # レコードを保存して、Changesテーブルを登録するメソッド
  def save_with_changes!
    ActiveRecord::Base.transaction do
      save!
      self.class.send(:create_from_original!, original_record: self, event: "create")
      self
    end
  end

  # レコードを更新して、Changesテーブルを登録するメソッド
  def update_with_changes!(attributes)
    ActiveRecord::Base.transaction do
      update!(attributes)
      self.class.send(:create_from_original!, original_record: self, event: "update")
      self
    end
  end

  # レコードを削除して、Changesテーブルを登録するメソッド
  def destroy_with_changes!
    ActiveRecord::Base.transaction do
      self.class.send(:create_from_original!, original_record: self, event: "delete")
      destroy!
    end
  end

  module ClassMethods
    # レコードを登録して、Changesテーブルを登録するメソッド
    def create_with_changes!(attributes)
      ActiveRecord::Base.transaction do
        instance = create!(attributes)
        create_from_original!(original_record: instance, event: "create")
        instance
      end
    end

    private

    # includeしたモデルのChangeテーブルへの保存処理を実行するメソッド
    # evalを利用していることもあり、外部から利用されたくないので、privateにしている。
    def create_from_original!(original_record:, event:)
      eval("#{self}Change", binding, __FILE__, __LINE__).create_from_original!(
        original_record: original_record,
        event: event,
      )
    end
  end
end
