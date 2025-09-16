require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:item) { create(:item) }
  let(:valid_attributes) do
    {
      nome: 'Novo Item',
      preco: 25.0,
      peso: 1.0,
      descricao: 'Descrição do item',
      categoria: 'categoria_teste',
      disponivel: true,
      ativo: true
    }
  end

  let(:invalid_attributes) do
    {
      nome: '', # nome é obrigatório
      preco: -10.0 # preço não pode ser negativo
    }
  end

  describe 'GET #index' do
    let!(:item_disponivel) { create(:item) } # disponivel: true por padrão
    let!(:item_indisponivel) { create(:item, :indisponivel) }

    context 'without todos parameter' do
      it 'assigns only available items' do
        get :index
        expect(assigns(:items)).to include(item_disponivel)
        expect(assigns(:items)).not_to include(item_indisponivel)
        expect(assigns(:showing_all)).to be false
      end
    end

    context 'with todos=true parameter' do
      it 'assigns all items' do
        get :index, params: { todos: 'true' }
        expect(assigns(:items)).to include(item_disponivel, item_indisponivel)
        expect(assigns(:showing_all)).to be true
      end
    end

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'assigns the requested item' do
      get :show, params: { id: item.id }
      expect(assigns(:item)).to eq(item)
    end

    it 'returns a successful response' do
      get :show, params: { id: item.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'assigns a new item' do
      get :new
      expect(assigns(:item)).to be_a_new(Item)
    end

    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested item' do
      get :edit, params: { id: item.id }
      expect(assigns(:item)).to eq(item)
    end

    it 'returns a successful response' do
      get :edit, params: { id: item.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Item' do
        expect {
          post :create, params: { item: valid_attributes }
        }.to change(Item, :count).by(1)
      end

      it 'redirects to the created item' do
        post :create, params: { item: valid_attributes }
        expect(response).to redirect_to(Item.last)
      end

      it 'sets a notice message' do
        post :create, params: { item: valid_attributes }
        expect(flash[:notice]).to eq('Item was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Item' do
        expect {
          post :create, params: { item: invalid_attributes }
        }.not_to change(Item, :count)
      end

      it 'renders the new template' do
        post :create, params: { item: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          nome: 'Item Atualizado',
          preco: 30.0
        }
      end

      it 'updates the requested item' do
        put :update, params: { id: item.id, item: new_attributes }
        item.reload
        expect(item.nome).to eq('Item Atualizado')
        expect(item.preco).to be_within(0.01).of(30.0)
      end

      it 'redirects to the item' do
        put :update, params: { id: item.id, item: new_attributes }
        expect(response).to redirect_to(item)
      end

      it 'sets a notice message' do
        put :update, params: { id: item.id, item: new_attributes }
        expect(flash[:notice]).to eq('Item was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'renders the edit template' do
        put :update, params: { id: item.id, item: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested item' do
      item # create the item
      expect {
        delete :destroy, params: { id: item.id }
      }.to change(Item, :count).by(-1)
    end

    it 'redirects to the items list' do
      delete :destroy, params: { id: item.id }
      expect(response).to redirect_to(items_path)
      expect(response).to have_http_status(:see_other)
    end

    it 'sets a notice message' do
      delete :destroy, params: { id: item.id }
      expect(flash[:notice]).to eq('Item was successfully destroyed.')
    end
  end

  describe 'JSON responses' do
    describe 'POST #create' do
      context 'with valid parameters' do
        it 'returns created status' do
          post :create, params: { item: valid_attributes }, format: :json
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          post :create, params: { item: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        it 'returns ok status' do
          put :update, params: { id: item.id, item: { nome: 'Updated' } }, format: :json
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          put :update, params: { id: item.id, item: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'returns no content status' do
        delete :destroy, params: { id: item.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
