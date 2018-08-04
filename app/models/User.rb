# == Schema Information
#
# Table name: users # ��`���`���
#
#  id              :bigint(8)        not null, primary key
#  email           :string(255)      not null                 # ��`�륢�ɥ쥹
#  password_digest :string(255)      not null                 # �ѥ���`��
#  freezed         :boolean          default(FALSE), not null # ���Y״�B
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_secure_password
  has_one :user_profile, dependent: :destroy
  has_one :provisional_user_completed_log, dependent: :destroy
  has_many :user_freezed_reasons, dependent: :destroy
  has_many :user_unfreezed_reasons, dependent: :destroy
  has_many :user_auth_logs, dependent: :destroy

  # TODO(shuji ota):��ʽ�����å���validation��׷�Ӥ���
  validates :email, presence: true, uniqueness: true

  # TODO(shuji ota):��ʽ�����å���validation��׷�Ӥ���
  validates :password_digest, presence: true

  class << self
    # ��T��_changes�Ʃ`�֥�ȤȤ������᥽�å�
    def create_with_changes!(email:, password_digest:)
      ActiveRecord::Base.transaction do
        user = create!(email: email, password_digest: password_digest)
        UserChange.create_from_original!(original_record: user, event: "create")
        user
      end
    end

    # ����T���h�����ˤ�����᥽�å�
    def complete_registration(provisional_user)
      ActiveRecord::Base.transaction do
        user = create_with_changes!(email: provisional_user.email, password_digest: provisional_user.password_digest)
        ProvisionalUserCompletedLog.create!(user_id: user.id, provisional_user_id: provisional_user.id)
        user
      end
    end

    # ���󥹥��󥹤˸�{����Ƥ�email�����Ǥ�user�˵��h����Ƥ��Τ��ɤ������ж�����᥽�å�
    def signuped_email?(provisional_user)
      exists?(email: provisional_user.email)
    end

    # TODO(shuji ota):URL�ˤĤ��Ƥ���ȩ`���������Ф�Ǥʤ�����_�����᥽�åɤ�����
  end
end


