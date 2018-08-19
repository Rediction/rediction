shared_context "current_userとしてログイン後にアクセスする" do
  let(:current_user) { create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
  end
end

shared_context "APIを認証済み状態にする" do
  before do
    allow_any_instance_of(Api::SecureApplicationController).to receive(:authenticate)
  end
end

shared_context "current_admin_userとしてログイン後にアクセスする" do
  let(:current_admin_user) { create(:admin_user) }

  before do
    allow_any_instance_of(Admin::ApplicationController).to receive(:current_admin_user).and_return(current_admin_user)
  end
end
