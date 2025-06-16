class PorcaosController < ApplicationController
  before_action :set_porcao, only: %i[ show edit update destroy ]

  # GET /porcaos or /porcaos.json
  def index
    @porcaos = Porcao.all
  end

  # GET /porcaos/1 or /porcaos/1.json
  def show
  end

  # GET /porcaos/new
  def new
    @porcao = Porcao.new
  end

  # GET /porcaos/1/edit
  def edit
  end

  # POST /porcaos or /porcaos.json
  def create
    @porcao = Porcao.new(porcao_params)

    respond_to do |format|
      if @porcao.save
        format.html { redirect_to @porcao, notice: "Porcao was successfully created." }
        format.json { render :show, status: :created, location: @porcao }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @porcao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /porcaos/1 or /porcaos/1.json
  def update
    respond_to do |format|
      if @porcao.update(porcao_params)
        format.html { redirect_to @porcao, notice: "Porcao was successfully updated." }
        format.json { render :show, status: :ok, location: @porcao }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @porcao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /porcaos/1 or /porcaos/1.json
  def destroy
    @porcao.destroy!

    respond_to do |format|
      format.html { redirect_to porcaos_path, status: :see_other, notice: "Porcao was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_porcao
      @porcao = Porcao.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def porcao_params
      params.expect(porcao: [ :item_id, :peso_utilizado, :custo ])
    end
end
