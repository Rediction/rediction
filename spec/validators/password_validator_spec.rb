require "rails_helper"

describe PasswordValidator, type: :validator do
  let(:klass) do
    Struct.new(:password) do
      include ActiveModel::Validations

      def self.name
        "PasswordValidator"
      end

      validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$%?\/+\-])[a-zA-Z0-9!@#$%?\/+\-]+\z/}
    end
  end

  describe "#validate_each", type: :doing do
    subject { klass.new(password) }

    context "大文字アルファベットを含んでいない場合" do
      let(:password) { "password1!" }

      it { is_expected.to_not be_valid }
    end

    context "小文字アルファベットを含んでいない場合" do
      let(:password) { "PASSWORD1!" }

      it { is_expected.to_not be_valid }
    end

    context "数字を含んでいない場合" do
      let(:password) { "Password!" }

      it { is_expected.to_not be_valid }
    end

    context "記号を含んでいない場合" do
      let(:password) { "Password1" }

      it { is_expected.to_not be_valid }
    end
  end

  describe "success", type: :doing do
    subject { klass.new(password) }

    context "全て含まれている場合" do
      let(:password) { "Password1!" }

      it { is_expected.to be_valid }
    end
  end
end
