class ComprasController < ApplicationController
  before_action :set_compra, only: %i[ show edit update destroy ]

  # GET /compras or /compras.json
  def index
    @compras = Compra.all
  end

  # GET /compras/1 or /compras/1.json
  def show
  end

  # GET /compras/new
  def new
    @compra = Compra.new
    @compra.data_compra = Date.current
  end

  # GET /items/:id/data - Para buscar dados do item via AJAX
  def item_data
    item = Item.find(params[:id])
    render json: {
      nome: item.nome,
      preco: item.preco,
      peso: item.peso
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Item não encontrado" }, status: 404
  end

  # GET /compras/1/edit
  def edit
  end

  # POST /compras or /compras.json
  def create
    @compra = Compra.new(compra_params)

    respond_to do |format|
      if @compra.save
        format.html { redirect_to @compra, notice: "Compra was successfully created." }
        format.json { render :show, status: :created, location: @compra }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @compra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compras/1 or /compras/1.json
  def update
    respond_to do |format|
      if @compra.update(compra_params)
        format.html { redirect_to @compra, notice: "Compra was successfully updated." }
        format.json { render :show, status: :ok, location: @compra }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @compra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compras/1 or /compras/1.json
  def destroy
    @compra.destroy!

    respond_to do |format|
      format.html { redirect_to compras_path, status: :see_other, notice: "Compra was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compra
      @compra = Compra.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def compra_params
      params.expect(compra: [ :item_id, :nome, :preco, :peso, :data_compra ])
    end
end
