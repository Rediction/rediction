require "rails_helper"

describe Admin::WordsController, type: :controller do
  include_context 'current_admin_userとしてログイン後にアクセスする'

  describe "GET #index" do
    subject { get :index }
    before { subject }
    let(:pagination_per) { 20 }

    context "ページネーションの制限以下にユーザーが登録されている場合" do
      before { create_list(:word, pagination_per) }

      it "登録されているユーザー全てが取得されること", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index
      end

      it "ページネーション制限数分のみユーザーが取得されていること" do
        expect(assigns(:words).size).to eq pagination_per
      end

      it "IDの順で取得されていること" do
        expect(assigns(:words).first).to eq Word.last
      end
    end

    context "ページネーションの制限以上にユーザーが登録されている場合" do
      before { create_list(:word, pagination_per + 1) }

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :index
      end

      it "ページネーション制限数分のみユーザーが取得されていること" do
        expect(assigns(:words).size).to eq pagination_per
      end

      it "IDの順で取得されていること" do
        expect(assigns(:words).first).to eq Word.last
      end
    end
  end

  describe "GET #show" do
    subject { get :show, params: { id: word_id } }
    let(:word_id) { word.id }
    let(:word) { create(:word) }

    context "平常時アクセスの場合" do
      before { subject }

      it "HTTP 200 OK", :aggregate_failures do
        expect(response).to have_http_status 200
        expect(response).to render_template :show
      end

      it "paramsにあるIDに該当するユーザーがインスタンスに格納されていること" do
        expect(assigns(:word)).to eq word
      end
    end

    context "idに該当するユーザーが登録されていない場合" do
      let(:word_id) { 0 }

      it "HTTP 404 Not Found" do
        expect{ subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: { id: word_id } }
    let(:word_id) { word.id }
    let(:word) { create(:word) }

    context "平常時アクセスの場合" do
      it "HTTP 200 OK", :aggregate_failures do
        subject
        expect(response).to have_http_status 302
        expect(response).to redirect_to admin_words_path
        expect(flash[:success]).to eq "言葉ID #{word_id}を削除しました。"
      end

      it "レコードが削除されていること", :aggregate_failures do
        word
        expect{ subject }.to change(Word, :count).by(-1)
        expect(Word.exists?(id: word_id)).to eq false
      end
    end

    context "idに該当するユーザーが登録されていない場合" do
      let(:word_id) { 0 }

      it "HTTP 404 Not Found" do
        expect{ subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
