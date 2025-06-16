class LanchesController < ApplicationController
  before_action :set_lanch, only: %i[ show edit update destroy remove_photo ]

  # GET /lanches or /lanches.json
  def index
    @lanches = Lanch.all
  end

  # GET /lanches/1 or /lanches/1.json
  def show
  end

  # GET /lanches/new
  def new
    @lanch = Lanch.new
  end

  # GET /lanches/1/edit
  def edit
  end

  # POST /lanches or /lanches.json
  def create
    @lanch = Lanch.new(lanch_params)

    respond_to do |format|
      if @lanch.save
        # Processar fotos após salvar o lanche
        if params[:lanch][:fotos].present?
          adicionar_fotos_ao_lanche
        end

        format.html { redirect_to @lanch, notice: "Lanche foi criado com sucesso." }
        format.json { render :show, status: :created, location: @lanch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lanch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lanches/1 or /lanches/1.json
  def update
    respond_to do |format|
      # Processar fotos separadamente para adicionar ao invés de substituir
      if params[:lanch][:fotos].present?
        adicionar_fotos_ao_lanche
        params[:lanch].delete(:fotos)  # Remove do params para não sobrescrever
      end

      if @lanch.update(lanch_params)
        format.html { redirect_to @lanch, notice: "Lanche foi atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @lanch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lanch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lanches/1 or /lanches/1.json
  def destroy
    @lanch.destroy!

    respond_to do |format|
      format.html { redirect_to lanches_path, status: :see_other, notice: "Lanche foi excluído com sucesso." }
      format.json { head :no_content }
    end
  end

  # DELETE /lanches/1/remove_photo/attachment_id
  def remove_photo
    photo = @lanch.fotos.find(params[:photo_id])
    photo.purge

    respond_to do |format|
      format.html { redirect_to edit_lanch_path(@lanch), notice: "Foto removida com sucesso." }
      format.json { head :no_content }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to edit_lanch_path(@lanch), alert: "Foto não encontrada." }
      format.json { head :not_found }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lanch
      @lanch = Lanch.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lanch_params
      params.expect(lanch: [ :nome, :ingredientes, :custo, :preco_sugerido, porcao_ids: [], fotos: [] ])
    end

    # Adiciona fotos ao lanche sem substituir as existentes
    def adicionar_fotos_ao_lanche
      fotos_para_adicionar = params[:lanch][:fotos].reject(&:blank?)

      fotos_para_adicionar.each do |foto|
        # Verifica se não excede o limite de 3 fotos
        if @lanch.fotos.count < 3
          @lanch.fotos.attach(foto)
        else
          @lanch.errors.add(:fotos, "Máximo de 3 fotos permitidas")
          break
        end
      end
    end
end
