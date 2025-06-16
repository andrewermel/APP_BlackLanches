class LanchesController < ApplicationController
  before_action :set_lanch, only: %i[ show edit update destroy ]

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
        format.html { redirect_to @lanch, notice: "Lanch was successfully created." }
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
      if @lanch.update(lanch_params)
        format.html { redirect_to @lanch, notice: "Lanch was successfully updated." }
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
      format.html { redirect_to lanches_path, status: :see_other, notice: "Lanch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lanch
      @lanch = Lanch.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lanch_params
      params.expect(lanch: [ :nome, :ingredientes, :custo, :preco_sugerido, porcao_ids: [] ])
    end
end
