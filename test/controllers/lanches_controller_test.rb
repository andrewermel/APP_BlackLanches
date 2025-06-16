require "test_helper"

class LanchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lanch = lanches(:one)
  end

  test "should get index" do
    get lanches_url
    assert_response :success
  end

  test "should get new" do
    get new_lanch_url
    assert_response :success
  end

  test "should create lanch" do
    assert_difference("Lanch.count") do
      post lanches_url, params: { lanch: { custo: @lanch.custo, ingredientes: @lanch.ingredientes, nome: @lanch.nome, preco_sugerido: @lanch.preco_sugerido } }
    end

    assert_redirected_to lanch_url(Lanch.last)
  end

  test "should show lanch" do
    get lanch_url(@lanch)
    assert_response :success
  end

  test "should get edit" do
    get edit_lanch_url(@lanch)
    assert_response :success
  end

  test "should update lanch" do
    patch lanch_url(@lanch), params: { lanch: { custo: @lanch.custo, ingredientes: @lanch.ingredientes, nome: @lanch.nome, preco_sugerido: @lanch.preco_sugerido } }
    assert_redirected_to lanch_url(@lanch)
  end

  test "should destroy lanch" do
    assert_difference("Lanch.count", -1) do
      delete lanch_url(@lanch)
    end

    assert_redirected_to lanches_url
  end
end
