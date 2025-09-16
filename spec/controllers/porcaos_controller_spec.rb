require 'rails_helper'

RSpec.describe PorcaosController, type: :controller do
  let(:item) { create(:item) }
  let(:porcao) { create(:porcao, item: item) }

  let(:valid_attributes) do
    {
      nome: 'Nova Porção',
      item_id: item.id,
      peso_utilizado: 0.5
    }
  end

  let(:invalid_attributes) do
    {
      nome: '', # nome é obrigatório
      peso_utilizado: -1.0 # peso não pode ser negativo
    }
  end

  describe 'GET #index' do
    let!(:porcao1) { create(:porcao) }
    let!(:porcao2) { create(:porcao) }

    it 'assigns all porcaos' do
      get :index
      expect(assigns(:porcaos)).to include(porcao1, porcao2)
    end

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'assigns the requested porcao' do
      get :show, params: { id: porcao.id }
      expect(assigns(:porcao)).to eq(porcao)
    end

    it 'returns a successful response' do
      get :show, params: { id: porcao.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'assigns a new porcao' do
      get :new
      expect(assigns(:porcao)).to be_a_new(Porcao)
    end

    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested porcao' do
      get :edit, params: { id: porcao.id }
      expect(assigns(:porcao)).to eq(porcao)
    end

    it 'returns a successful response' do
      get :edit, params: { id: porcao.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Porcao' do
        expect {
          post :create, params: { porcao: valid_attributes }
        }.to change(Porcao, :count).by(1)
      end

      it 'redirects to the created porcao' do
        post :create, params: { porcao: valid_attributes }
        expect(response).to redirect_to(Porcao.last)
      end

      it 'sets a notice message' do
        post :create, params: { porcao: valid_attributes }
        expect(flash[:notice]).to eq('Porcao was successfully created.')
      end

      it 'calculates custo automatically' do
        post :create, params: { porcao: valid_attributes }
        created_porcao = Porcao.last
        expected_custo = item.preco * valid_attributes[:peso_utilizado]
        expect(created_porcao.custo).to be_within(0.01).of(expected_custo)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Porcao' do
        expect {
          post :create, params: { porcao: invalid_attributes }
        }.not_to change(Porcao, :count)
      end

      it 'renders the new template' do
        post :create, params: { porcao: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          nome: 'Porção Atualizada',
          peso_utilizado: 0.8
        }
      end

      it 'updates the requested porcao' do
        put :update, params: { id: porcao.id, porcao: new_attributes }
        porcao.reload
        expect(porcao.nome).to eq('Porção Atualizada')
        expect(porcao.peso_utilizado).to be_within(0.01).of(0.8)
      end

      it 'redirects to the porcao' do
        put :update, params: { id: porcao.id, porcao: new_attributes }
        expect(response).to redirect_to(porcao)
      end

      it 'sets a notice message' do
        put :update, params: { id: porcao.id, porcao: new_attributes }
        expect(flash[:notice]).to eq('Porcao was successfully updated.')
      end

      it 'recalculates custo when peso_utilizado changes' do
        original_custo = porcao.custo
        put :update, params: { id: porcao.id, porcao: new_attributes }
        porcao.reload
        expect(porcao.custo).not_to eq(original_custo)
        expected_custo = porcao.item.preco * 0.8
        expect(porcao.custo).to be_within(0.01).of(expected_custo)
      end
    end

    context 'with invalid parameters' do
      it 'renders the edit template' do
        put :update, params: { id: porcao.id, porcao: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested porcao' do
      porcao # create the porcao
      expect {
        delete :destroy, params: { id: porcao.id }
      }.to change(Porcao, :count).by(-1)
    end

    it 'redirects to the porcaos list' do
      delete :destroy, params: { id: porcao.id }
      expect(response).to redirect_to(porcaos_path)
      expect(response).to have_http_status(:see_other)
    end

    it 'sets a notice message' do
      delete :destroy, params: { id: porcao.id }
      expect(flash[:notice]).to eq('Porcao was successfully destroyed.')
    end
  end

  describe 'JSON responses' do
    describe 'POST #create' do
      context 'with valid parameters' do
        it 'returns created status' do
          post :create, params: { porcao: valid_attributes }, format: :json
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          post :create, params: { porcao: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        it 'returns ok status' do
          put :update, params: { id: porcao.id, porcao: { nome: 'Updated' } }, format: :json
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          put :update, params: { id: porcao.id, porcao: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'returns no content status' do
        delete :destroy, params: { id: porcao.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
