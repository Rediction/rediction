require "rails_helper"

describe Admin::User::FreezedReasonsController, type: :controller do
  include_context "current_admin_userとしてログイン後にアクセスする"
  let(:user) { create(:user) }

  shared_context "user_idに該当するユーザーが未凍結の場合" do
    context do
      let(:user) { create(:user, freezed: :freezed) }

      it "404が発生すること" do
        expect{ subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "GET #new" do
    subject { get :new, params: params }
    let(:params) { { user_id: user_id } }
    let(:user_id) { user.id }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        subject
        expect(response).to have_http_status 200
        expect(response).to render_template :new
        expect(assigns(:freezed_reason).class).to eq User::FreezedReason
      end
    end

    include_context "user_idに該当するユーザーが未凍結の場合"
  end

  describe "POST #create" do
    subject { post :create, params: params }
    let(:params) { { user_freezed_reason: { description: description }, user_id: user.id } }
    let(:description) { "description" }

    context "登録に成功した場合" do
      it "HTTP 302 Moved Temporarily", :aggregate_failures do
        subject
        expect(response).to have_http_status 302
        expect(flash[:success]).to eq "ユーザーを凍結しました。"
        expect(response).to redirect_to admin_user_path(assigns(:user))
      end

      it "レコードが生成されること" do
        expect{ subject }.to change(UserChange, :count).by(1).and change(User::FreezedReason, :count).by(1)
      end

      it "ユーザーの凍結状態がtrue(凍結)になること" do
        expect{ subject }.to change{ user.reload.freezed? }.from(false).to(true)
      end

      it "ユーザーのchangesテーブルの凍結状態がtrue(凍結)で登録されていること" do
        expect{ subject }.to change{ UserChange.last&.freezed? }.from(nil).to(true)
      end
    end

    context "登録に失敗した場合" do
      # descriptionのValidation設定(文字数140文字以内に引っかかるようにしている)
      let(:description) { "あ" * 141 }

      it "HTTP 200 OK", :aggregate_failures do
        subject
        expect(response).to have_http_status 200
        expect(response).to render_template :new
        expect(flash[:error]).to eq "ユーザーの凍結に失敗しました。"
      end

      it "レコードが生成されていないこと" do
        expect{ subject }.to change(UserChange, :count).by(0).and change(User::FreezedReason, :count).by(0)
      end

      it "ユーザーの凍結状態がfalseのままであること" do
        subject
        expect(user.unfreezed?).to eq true
      end
    end

    include_context "user_idに該当するユーザーが未凍結の場合"
  end
end
