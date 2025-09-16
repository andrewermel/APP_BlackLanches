require 'rails_helper'

RSpec.describe ComprasController, type: :controller do
  let(:item) { create(:item) }
  let(:compra) { create(:compra, item: item) }

  let(:valid_attributes) do
    {
      item_id: item.id,
      nome: 'Compra de Teste',
      preco: 25.0,
      peso: 2.0,
      data_compra: Date.current
    }
  end

  let(:invalid_attributes) do
    {
      nome: '', # nome é obrigatório
      preco: -10.0 # preço não pode ser negativo
    }
  end

  describe 'GET #index' do
    let!(:compra1) { create(:compra) }
    let!(:compra2) { create(:compra) }

    it 'assigns all compras' do
      get :index
      expect(assigns(:compras)).to include(compra1, compra2)
    end

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'assigns the requested compra' do
      get :show, params: { id: compra.id }
      expect(assigns(:compra)).to eq(compra)
    end

    it 'returns a successful response' do
      get :show, params: { id: compra.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'assigns a new compra' do
      get :new
      expect(assigns(:compra)).to be_a_new(Compra)
    end

    it 'sets data_compra to current date' do
      get :new
      expect(assigns(:compra).data_compra).to eq(Date.current)
    end

    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested compra' do
      get :edit, params: { id: compra.id }
      expect(assigns(:compra)).to eq(compra)
    end

    it 'returns a successful response' do
      get :edit, params: { id: compra.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #item_data' do
    it 'returns item data as JSON' do
      get :item_data, params: { id: item.id }, format: :json

      expect(response).to be_successful
      json_response = JSON.parse(response.body)
      expect(json_response['nome']).to eq(item.nome)
      expect(json_response['preco']).to eq(item.preco.to_s)
      expect(json_response['peso']).to eq(item.peso.to_s)
    end

    it 'returns error when item not found' do
      get :item_data, params: { id: 999999 }, format: :json

      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Item não encontrado')
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Compra' do
        expect {
          post :create, params: { compra: valid_attributes }
        }.to change(Compra, :count).by(1)
      end

      it 'redirects to the created compra' do
        post :create, params: { compra: valid_attributes }
        expect(response).to redirect_to(Compra.last)
      end

      it 'sets a notice message' do
        post :create, params: { compra: valid_attributes }
        expect(flash[:notice]).to eq('Compra was successfully created.')
      end

      it 'updates item average price' do
        original_price = item.preco
        post :create, params: { compra: valid_attributes }

        item.reload
        # O preço do item deve ser atualizado com a média das compras
        expect(item.preco).not_to eq(original_price)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Compra' do
        expect {
          post :create, params: { compra: invalid_attributes }
        }.not_to change(Compra, :count)
      end

      it 'renders the new template' do
        post :create, params: { compra: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          nome: 'Compra Atualizada',
          preco: 30.0
        }
      end

      it 'updates the requested compra' do
        put :update, params: { id: compra.id, compra: new_attributes }
        compra.reload
        expect(compra.nome).to eq('Compra Atualizada')
        expect(compra.preco).to be_within(0.01).of(30.0)
      end

      it 'redirects to the compra' do
        put :update, params: { id: compra.id, compra: new_attributes }
        expect(response).to redirect_to(compra)
      end

      it 'sets a notice message' do
        put :update, params: { id: compra.id, compra: new_attributes }
        expect(flash[:notice]).to eq('Compra was successfully updated.')
      end

      it 'updates item average price when compra price changes' do
        original_item_price = compra.item.preco
        put :update, params: { id: compra.id, compra: new_attributes }

        compra.item.reload
        expect(compra.item.preco).not_to eq(original_item_price)
      end
    end

    context 'with invalid parameters' do
      it 'renders the edit template' do
        put :update, params: { id: compra.id, compra: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested compra' do
      compra # create the compra
      expect {
        delete :destroy, params: { id: compra.id }
      }.to change(Compra, :count).by(-1)
    end

    it 'redirects to the compras list' do
      delete :destroy, params: { id: compra.id }
      expect(response).to redirect_to(compras_path)
      expect(response).to have_http_status(:see_other)
    end

    it 'sets a notice message' do
      delete :destroy, params: { id: compra.id }
      expect(flash[:notice]).to eq('Compra was successfully destroyed.')
    end

    it 'updates item average price when compra is destroyed' do
      # Criar uma segunda compra para o mesmo item usando o item já existente na variável `compra`
      item_usado = compra.item
      create(:compra, item: item_usado, preco: 50.0)

      # Garantir que há pelo menos 2 compras para o item
      expect(item_usado.compras.count).to be >= 2

      original_item_price = item_usado.reload.preco

      delete :destroy, params: { id: compra.id }

      # Verificar que ainda existe pelo menos uma compra após a exclusão
      item_usado.reload
      if item_usado.compras.count > 0
        expect(item_usado.preco).not_to eq(original_item_price)
      else
        # Se não há mais compras, o preço pode ser resetado para 0
        expect(item_usado.preco).to be_present
      end
    end
  end

  describe 'JSON responses' do
    describe 'POST #create' do
      context 'with valid parameters' do
        it 'returns created status' do
          post :create, params: { compra: valid_attributes }, format: :json
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          post :create, params: { compra: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        it 'returns ok status' do
          put :update, params: { id: compra.id, compra: { nome: 'Updated' } }, format: :json
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          put :update, params: { id: compra.id, compra: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'returns no content status' do
        delete :destroy, params: { id: compra.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
