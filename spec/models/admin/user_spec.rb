# == Schema Information
#
# Table name: admin_users # 管理者ユーザー
#
#  id         :bigint(8)        not null, primary key
#  email      :string(255)      not null              # メールアドレス
#  uid        :string(255)                            # OAuth用のユニークID
#  created_at :datetime         not null
#

require "rails_helper"

RSpec.describe Admin::User, type: :model do
  let(:admin_user) { create(:admin_user) }

  describe "Instanceメソッド" do
    describe "Private" do
      describe "#valid_email_domain" do
        subject { admin_user.send(:valid_email_domain) }
        before { subject }

        context "emailの形式がVALID_EMAIL_DOMAINに一致する場合" do
          let(:admin_user) { build(:admin_user) }

          it "エラーが格納されていないこと" do
            expect(admin_user.errors.messages[:email].count).to eq 0
          end
        end

        context "emailの形式がVALID_EMAIL_DOMAINに一致しない場合" do
          let(:admin_user) { build(:admin_user, email: "hoge@hoge.com") }

          it "エラーが格納されていること" do
            expect(admin_user.errors.messages[:email].first).to eq "許可されていないメールアドレスです"
          end
        end
      end
    end
  end

  describe "Classメソッド" do
    describe ".authenticate_by_google_omniauth_info!" do
      subject { Admin::User.authenticate_by_google_omniauth_info!(google_omniauth_info) }
      let(:google_omniauth_info) { { "uid" => uid, "info" => { "email" => email } } } # rubocop:disable Style/StringHashKeys

      context "uidが登録済みの管理者ユーザーの情報とgoogle_omniauth_infoが一致する場合" do
        let(:uid) { admin_user.uid }
        let(:email) { admin_user.email }

        it "該当する管理者ユーザーが取得できること" do
          is_expected.to eq admin_user
        end
      end

      context "uidが未登録の管理者ユーザーのemailとgoogle_omniauth_infoが一致する場合" do
        let(:admin_user) { create(:admin_user, uid: nil) }
        let(:uid) { "xxxxxxxxxxx" }
        let(:email) { admin_user.email }

        it "該当する管理者ユーザーが取得できること" do
          is_expected.to eq admin_user
        end

        it "uidが取得した管理者ユーザーのレコードに登録されること" do
          expect{ subject }.to change{ admin_user.reload.uid }.from(nil).to(uid)
        end
      end

      context "OAuthログインしたemailが管理者ユーザーとして登録されていない場合" do
        let(:uid) { "xxxxxxxxxxx" }
        let(:email) { "hoge@gmail.com" }

        it "404が発生すること" do
          expect{ subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context "OAuthログインしたアカウントのuidに一致する管理者ユーザーが登録されていない場合" do
        let(:uid) { "hoge" }
        let(:email) { admin_user.email }

        it "404が発生すること" do
          expect{ subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
