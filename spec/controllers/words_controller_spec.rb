require "rails_helper"

describe WordsController, type: :controller do
  include_context 'current_userとしてログイン後にアクセスする'

  describe "GET #index_latest_order" do
    subject { get :index_latest_order }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index_latest_order
      end
    end
  end

  describe "GET #index_random_order" do
    subject { get :index_random_order }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index_random_order
      end
    end
  end

  describe "GET #index_scoped_favorite_words" do
    subject { get :index_scoped_favorite_words }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index_scoped_favorite_words
      end
    end
  end

  describe "GET #index_scoped_follow_users" do
    subject { get :index_scoped_follow_users }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index_scoped_follow_users
      end
    end
  end

  describe "GET #search" do
    subject { get :search }
    before { subject }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :search
      end
    end
  end

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

  describe "GET #show" do
    subject { get :show, params: { id: word.id } }
    before { subject }

    context "平常時アクセスの場合" do
      let(:word) { create(:word) }
      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end
    end
  end

  describe "POST #create" do
    let(:word_params) { attributes_for(:word) }

    context "@wordの保存に成功した場合" do
      subject{ post :create, params: { word: word_params } }

      it "レコードが生成されること", :aggregate_failures do
        expect{ subject }.to change(Word, :count).by(1)
        expect(response).to have_http_status 302
        expect(flash[:success]).to eq "投稿しました。"
        expect(response).to redirect_to user_mypage_path
      end
    end

    context "@wordの保存に失敗した場合" do
      subject{ post :create, params: { word: word_params.merge(description: description) } }
      let(:description) { "" }

      it "レコードが生成されず、newテンプレートにrenderすること", :aggregate_failures do
        expect{ subject }.to change(Word, :count).by(0)
        expect(flash[:error]).to eq "投稿に失敗しました。"
        expect(response).to render_template :new
      end
    end
  end
end
