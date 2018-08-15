# Changesテーブルを有するテーブル用のテスト。
# PerformableWithChangesモジュールがincludeされていることを想定しており、モジュールのメソッドが正常に動作するかを確認する。
# include_contextを利用して本テストをincludeして、引数に対象のクラス(Originalの方のクラス)を設定する必要がある。
shared_context "Changesテーブルを有する場合" do |original_class|
  describe "PerformableWithChangesモジュールをincludeしている場合" do
    FACTORY_BOT_KEY = original_class.to_s.underscore.tr("/", "_").to_sym.freeze unless defined? FACTORY_BOT_KEY
    ORIGINAL_CLASS = original_class unless defined? ORIGINAL_CLASS
    CHANGES_CLASS = eval("#{original_class}Change", binding, __FILE__, __LINE__) unless defined? CHANGES_CLASS

    let(:created_instance) { create(FACTORY_BOT_KEY) }
    let(:builded_instance) { build(FACTORY_BOT_KEY) }

    shared_context "OriginalのテーブルとChanges(履歴)テーブルのレコードそれぞれが正常に増減していること" do |original:, changes:|
      it { expect{ subject }.to change(ORIGINAL_CLASS, :count).by(original).and change(CHANGES_CLASS, :count).by(changes) }
    end

    shared_context "Changesテーブルのeventが正常に登録されていること" do |event:|
      it { expect{ subject }.to change{ CHANGES_CLASS.last&.event }.from(nil).to(event) }
    end

    shared_context "保存したレコードのインスタンスが返されること" do
      it { is_expected.to eq ORIGINAL_CLASS.last }
    end

    shared_context "OriginalのテーブルとChanges(履歴)テーブルのレコードが増えていないこと" do
      it do
        expect{ subject }.to \
          raise_error(ActiveRecord::RecordInvalid).and \
          change(ORIGINAL_CLASS, :count).by(0).and \
          change(CHANGES_CLASS, :count).by(0)
      end
    end

    describe "save_with_changes!" do
      subject { builded_instance.save_with_changes! }

      context "保存処理が成功した場合" do
        include_context "OriginalのテーブルとChanges(履歴)テーブルのレコードそれぞれが正常に増減していること", original: 1, changes: 1

        include_context "Changesテーブルのeventが正常に登録されていること", event: "create"

        include_context "保存したレコードのインスタンスが返されること"
      end

      context "保存処理に失敗した場合" do
        before { allow(builded_instance).to receive(:save!).and_raise(ActiveRecord::RecordInvalid) }

        include_context "OriginalのテーブルとChanges(履歴)テーブルのレコードが増えていないこと"
      end
    end

    describe "update_with_changes!" do
      subject { created_instance.update_with_changes!(created_instance.attributes) }
      before { created_instance }

      context "更新処理が成功した場合" do
        include_context "OriginalのテーブルとChanges(履歴)テーブルのレコードそれぞれが正常に増減していること", original: 0, changes: 1

        include_context "Changesテーブルのeventが正常に登録されていること", event: "update"

        include_context "保存したレコードのインスタンスが返されること"
      end

      context "保存処理に失敗した場合" do
        before { allow(created_instance).to receive(:update!).and_raise(ActiveRecord::RecordInvalid) }

        include_context "OriginalのテーブルとChanges(履歴)テーブルのレコードが増えていないこと"
      end
    end

    describe "destroy_with_changes!" do
      subject { created_instance.destroy_with_changes! }
      before { created_instance }

      context "保存処理が成功した場合" do
        include_context "OriginalのテーブルとChanges(履歴)テーブルのレコードそれぞれが正常に増減していること", original: -1, changes: 1

        include_context "Changesテーブルのeventが正常に登録されていること", event: "delete"

        it "保存したレコードのインスタンスが返されること" do
          is_expected.to eq created_instance
        end
      end

      context "保存処理に失敗した場合" do
        before { allow(created_instance).to receive(:destroy!).and_raise(ActiveRecord::RecordInvalid) }

        include_context "OriginalのテーブルとChanges(履歴)テーブルのレコードが増えていないこと"
      end
    end

    describe "create_with_changes!" do
      subject { ORIGINAL_CLASS.create_with_changes!(builded_instance.attributes) }

      context "保存処理が成功した場合" do
        include_context "OriginalのテーブルとChanges(履歴)テーブルのレコードそれぞれが正常に増減していること", original: 1, changes: 1

        include_context "Changesテーブルのeventが正常に登録されていること", event: "create"

        include_context "保存したレコードのインスタンスが返されること"
      end

      context "保存処理に失敗した場合" do
        before { allow(ORIGINAL_CLASS).to receive(:create!).and_raise(ActiveRecord::RecordInvalid) }

        include_context "OriginalのテーブルとChanges(履歴)テーブルのレコードが増えていないこと"
      end
    end

    describe "create_from_original!" do
      subject { ORIGINAL_CLASS.send(:create_from_original!, original_record: created_instance, event: event) }

      CHANGES_CLASS::CHANGES_EVENT_TYPES.each do |event|
        context "enumに設定されているステータスをeventに入れた場合" do
          let(:event) { event }
          before { subject }

          it "eventの内容が正常に保存されること" do
            expect(CHANGES_CLASS.last.event).to eq event
          end
        end
      end

      context "eventに不正な内容が入っている場合" do
        let(:event) { "HOGE" }

        it "ActiveRecord::RecordInvalidが発生すること" do
          expect{ subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
