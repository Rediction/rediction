require "rails_helper"

describe UserProfilesController, type: :controller do
  include_context 'current_userとしてログイン後にアクセスする'

  describe "GET #new" do
    subject { get :new }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    subject { post :create }
  end

  describe "GET #edit" do
    subject { get :edit }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    subject { patch :update, params: { user_profile: user_profile_params } }
    let(:user_profile_params) { user_profile.attributes }
    let(:user_profile) { create(:user_profile, user: current_user) }

    context "正常に更新に成功した場合" do
      before { user_profile_params }

      it "HTTP 302", :aggregate_failures do
        subject
        expect(response).to have_http_status 302
        expect(response).to redirect_to user_mypage_path
        expect(flash[:success]).to eq "プロフィールを更新しました。"
      end

      it "eventがupdateのChangesテーブルのレコードが登録されていること", :aggregate_failures do
        expect{ subject }.to change(UserProfileChange, :count).by(1)
        expect(UserProfileChange.last.event).to eq "update"
        expect(UserProfileChange.last.user_profile_id).to eq user_profile.id
      end
    end

    context "更新に失敗した場合" do
      let(:user_profile_params) { user_profile.attributes.merge("job" => "") }
      before { subject }

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :edit
        expect(flash[:error]).to eq "プロフィールの更新に失敗しました。"
      end
    end
  end
end
