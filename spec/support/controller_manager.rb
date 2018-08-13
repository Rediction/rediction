shared_context "current_admin_userとしてログイン後にアクセスする" do
  let(:current_admin_user) { create(:admin_user) }

  before do
    allow_any_instance_of(Admin::ApplicationController).to receive(:current_admin_user).and_return(current_admin_user)
  end
end
