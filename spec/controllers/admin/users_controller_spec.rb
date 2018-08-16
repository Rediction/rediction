require "rails_helper"

describe Admin::UsersController, type: :controller do
  include_context 'current_admin_userとしてログイン後にアクセスする'

  describe "GET #index" do
    subject { get :index }
    before { subject }
    let(:pagination_per) { 20 }

    context "ページネーションの制限以下にユーザーが登録されている場合" do
      before { create_list(:user, pagination_per) }

      it "登録されているユーザー全てが取得されること", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index
      end

      it "ページネーション制限数分のみユーザーが取得されていること" do
        expect(assigns(:users).size).to eq pagination_per
      end

      it "IDの順で取得されていること" do
        expect(assigns(:users).first).to eq User.last
      end
    end

    context "ページネーションの制限以上にユーザーが登録されている場合" do
      before { create_list(:user, pagination_per + 1) }

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index
      end

      it "ページネーション制限数分のみユーザーが取得されていること" do
        expect(assigns(:users).size).to eq pagination_per
      end

      it "IDの順で取得されていること" do
        expect(assigns(:users).first).to eq User.last
      end
    end
  end

  describe "GET #show" do
    subject { get :show, params: { id: user_id } }
    let(:user_id) { user.id }
    let(:user) { create(:user) }

    context "平常時アクセスの場合" do
      before { subject }

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end

      it "paramsにあるIDに該当するユーザーがインスタンスに格納されていること" do
        expect(assigns(:user)).to eq user
      end
    end

    context "idに該当するユーザーが登録されていない場合" do
      let(:user_id) { 0 }

      it "HTTP 404 Not Found" do
        expect{ subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
