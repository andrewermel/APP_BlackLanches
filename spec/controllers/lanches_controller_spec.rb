require 'rails_helper'

RSpec.describe LanchesController, type: :controller do
  let(:lanch) { create(:lanch) }
  let(:porcao1) { create(:porcao) }
  let(:porcao2) { create(:porcao) }

  let(:valid_attributes) do
    {
      nome: 'Novo Lanche',
      ingredientes: 'Ingredientes do lanche',
      valor_venda: 25.0
    }
  end

  let(:invalid_attributes) do
    {
      nome: '' # nome é obrigatório
    }
  end

  describe 'GET #index' do
    let!(:lanch1) { create(:lanch, posicao: 1) }
    let!(:lanch2) { create(:lanch, posicao: 2) }

    it 'assigns all lanches' do
      get :index
      expect(assigns(:lanches)).to include(lanch1, lanch2)
    end

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'includes associated data for performance' do
      get :index
      # Verifica se as associações foram carregadas (evita N+1 queries)
      expect(assigns(:lanches).first.association(:lanche_porcaos)).to be_loaded
    end
  end

  describe 'GET #show' do
    it 'assigns the requested lanch' do
      get :show, params: { id: lanch.id }
      expect(assigns(:lanch)).to eq(lanch)
    end

    it 'returns a successful response' do
      get :show, params: { id: lanch.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'assigns a new lanch' do
      get :new
      expect(assigns(:lanch)).to be_a_new(Lanch)
    end

    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested lanch' do
      get :edit, params: { id: lanch.id }
      expect(assigns(:lanch)).to eq(lanch)
    end

    it 'returns a successful response' do
      get :edit, params: { id: lanch.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Lanch' do
        expect {
          post :create, params: { lanch: valid_attributes }
        }.to change(Lanch, :count).by(1)
      end

      it 'redirects to the created lanch' do
        post :create, params: { lanch: valid_attributes }
        expect(response).to redirect_to(Lanch.last)
      end

      it 'sets a notice message' do
        post :create, params: { lanch: valid_attributes }
        expect(flash[:notice]).to eq('Lanche foi criado com sucesso.')
      end
    end

    context 'with porcoes_com_quantidade' do
      it 'creates lanch with portions and quantities' do
        expect {
          post :create, params: {
            lanch: valid_attributes.merge(
              porcoes_com_quantidade: {
                porcao1.id.to_s => '2',
                porcao2.id.to_s => '1'
              }
            )
          }
        }.to change(Lanch, :count).by(1).and change(LanchePorcao, :count).by(2)

        created_lanch = Lanch.last
        expect(created_lanch.lanche_porcaos.find_by(porcao: porcao1).quantidade).to eq(2)
        expect(created_lanch.lanche_porcaos.find_by(porcao: porcao2).quantidade).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Lanch' do
        expect {
          post :create, params: { lanch: invalid_attributes }
        }.not_to change(Lanch, :count)
      end

      it 'renders the new template' do
        post :create, params: { lanch: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          nome: 'Lanche Atualizado',
          valor_venda: 30.0
        }
      end

      it 'updates the requested lanch' do
        put :update, params: { id: lanch.id, lanch: new_attributes }
        lanch.reload
        expect(lanch.nome).to eq('Lanche Atualizado')
        expect(lanch.valor_venda).to be_within(0.01).of(30.0)
      end

      it 'redirects to the lanch' do
        put :update, params: { id: lanch.id, lanch: new_attributes }
        expect(response).to redirect_to(lanch)
      end

      it 'sets a notice message' do
        put :update, params: { id: lanch.id, lanch: new_attributes }
        expect(flash[:notice]).to eq('Lanche foi atualizado com sucesso.')
      end
    end

    context 'with porcoes_com_quantidade' do
      before do
        # Criar algumas porções iniciais
        create(:lanche_porcao, lanch: lanch, porcao: porcao1, quantidade: 1)
      end

      it 'updates portions and quantities' do
        put :update, params: {
          id: lanch.id,
          lanch: {
            nome: lanch.nome,
            porcoes_com_quantidade: {
              porcao2.id.to_s => '3'
            }
          }
        }

        lanch.reload
        expect(lanch.lanche_porcaos.count).to eq(1)
        expect(lanch.lanche_porcaos.first.porcao).to eq(porcao2)
        expect(lanch.lanche_porcaos.first.quantidade).to eq(3)
      end
    end

    context 'with invalid parameters' do
      it 'renders the edit template' do
        put :update, params: { id: lanch.id, lanch: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested lanch' do
      lanch # create the lanch
      expect {
        delete :destroy, params: { id: lanch.id }
      }.to change(Lanch, :count).by(-1)
    end

    it 'redirects to the lanches list' do
      delete :destroy, params: { id: lanch.id }
      expect(response).to redirect_to(lanches_path)
      expect(response).to have_http_status(:see_other)
    end

    it 'sets a notice message' do
      delete :destroy, params: { id: lanch.id }
      expect(flash[:notice]).to eq('Lanche foi excluído com sucesso.')
    end
  end

  describe 'DELETE #remove_photo' do
    context 'with valid photo' do
      it 'removes the photo and redirects with success message' do
        lanch_with_photo = create(:lanch)
        mock_photo = double('photo', purge: true)

        allow(Lanch).to receive(:find).and_return(lanch_with_photo)
        allow(lanch_with_photo.fotos).to receive(:find).with('1').and_return(mock_photo)

        delete :remove_photo, params: { id: lanch_with_photo.id, photo_id: '1' }
        expect(response).to redirect_to(edit_lanch_path(lanch_with_photo))
        expect(flash[:notice]).to eq('Foto removida com sucesso.')
      end
    end

    context 'when photo is not found' do
      it 'redirects with error message' do
        lanch_with_photo = create(:lanch)

        allow(Lanch).to receive(:find).and_return(lanch_with_photo)
        allow(lanch_with_photo.fotos).to receive(:find).with('999').and_raise(ActiveRecord::RecordNotFound)

        delete :remove_photo, params: { id: lanch_with_photo.id, photo_id: '999' }
        expect(response).to redirect_to(edit_lanch_path(lanch_with_photo))
        expect(flash[:alert]).to eq('Foto não encontrada.')
      end
    end
  end

  describe 'POST #move_up' do
    let!(:lanch1) { create(:lanch, posicao: 1) }
    let!(:lanch2) { create(:lanch, posicao: 2) }

    it 'moves lanch up in position' do
      post :move_up, params: { id: lanch2.id }

      lanch1.reload
      lanch2.reload

      expect(lanch1.posicao).to eq(2)
      expect(lanch2.posicao).to eq(1)
      expect(response).to redirect_to(lanches_path)
      expect(flash[:notice]).to eq('Lanche movido para cima.')
    end

    it 'does not move first lanch up' do
      original_position = lanch1.posicao
      post :move_up, params: { id: lanch1.id }

      lanch1.reload
      expect(lanch1.posicao).to eq(original_position)
    end
  end

  describe 'POST #move_down' do
    let!(:lanch1) { create(:lanch, posicao: 1) }
    let!(:lanch2) { create(:lanch, posicao: 2) }

    it 'moves lanch down in position' do
      post :move_down, params: { id: lanch1.id }

      lanch1.reload
      lanch2.reload

      expect(lanch1.posicao).to eq(2)
      expect(lanch2.posicao).to eq(1)
      expect(response).to redirect_to(lanches_path)
      expect(flash[:notice]).to eq('Lanche movido para baixo.')
    end

    it 'does not move last lanch down' do
      original_position = lanch2.posicao
      post :move_down, params: { id: lanch2.id }

      lanch2.reload
      expect(lanch2.posicao).to eq(original_position)
    end
  end

  describe 'JSON responses' do
    describe 'POST #create' do
      context 'with valid parameters' do
        it 'returns created status' do
          post :create, params: { lanch: valid_attributes }, format: :json
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          post :create, params: { lanch: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        it 'returns ok status' do
          put :update, params: { id: lanch.id, lanch: { nome: 'Updated' } }, format: :json
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          put :update, params: { id: lanch.id, lanch: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'returns no content status' do
        delete :destroy, params: { id: lanch.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end

    describe 'DELETE #remove_photo' do
      context 'with valid photo' do
        it 'returns no content status' do
          lanch_with_photo = create(:lanch)
          mock_photo = double('photo', purge: true)

          allow(Lanch).to receive(:find).and_return(lanch_with_photo)
          allow(lanch_with_photo.fotos).to receive(:find).with('1').and_return(mock_photo)

          delete :remove_photo, params: { id: lanch_with_photo.id, photo_id: '1' }, format: :json
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when photo is not found' do
        it 'returns not found status' do
          lanch_with_photo = create(:lanch)

          allow(Lanch).to receive(:find).and_return(lanch_with_photo)
          allow(lanch_with_photo.fotos).to receive(:find).with('999').and_raise(ActiveRecord::RecordNotFound)

          delete :remove_photo, params: { id: lanch_with_photo.id, photo_id: '999' }, format: :json
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
