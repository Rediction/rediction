require "rails_helper"

describe PasswordValidator, type: :validator do
  let(:klass) do
    Struct.new(:password) do
      include ActiveModel::Validations
      validates :password, password: true
    end
  end

  describe "#validate_each" do
    subject { klass.new(password) }

    context "半角英字を含んでいない場合" do
      let(:password) { "11111111" }

      it { is_expected.to be_invalid }
    end

    context "数字を含んでいない場合" do
      let(:password) { "password" }

      it { is_expected.to be_invalid }
    end

    context "ひらがなを含んでいる場合" do
      let(:password) { "password1あ" }

      it { is_expected.to be_invalid }
    end

    describe "success" do
      context "半角小文字英字、半角数字の2種が含まれている場合" do
        let(:password) { "password1" }

        it { is_expected.to be_valid }
      end

      context "半角大文字英字、半角数字の2種が含まれている場合" do
        let(:password) { "PASSWORD1" }

        it { is_expected.to be_valid }
      end

      context "半角大文字英字、半角小文字英字、半角数字、記号の4種が含まれている場合" do
        let(:password) { "Password1!" }

        it { is_expected.to be_valid }
      end
    end
  end
end
