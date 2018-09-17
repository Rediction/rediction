require "rails_helper"

describe KatakanaValidator, type: :validator do
  let(:klass) do
    Struct.new(:first_name_kana) do
      include ActiveModel::Validations
      validates :first_name_kana, katakana: true
    end
  end

  describe "#validate_each" do
    subject { klass.new(first_name_kana) }

    context "カタカナ以外が使用されている場合" do
      let(:first_name_kana) { "あアa" }

      it { is_expected.to be_invalid }
    end

    context "カタカナのみが使用されている場合" do
      let(:first_name_kana) { "アイウエオ" }

      it { is_expected.to be_valid }
    end
  end
end
