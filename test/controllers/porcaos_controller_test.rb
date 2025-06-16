require "test_helper"

class PorcaosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @porcao = porcaos(:one)
  end

  test "should get index" do
    get porcaos_url
    assert_response :success
  end

  test "should get new" do
    get new_porcao_url
    assert_response :success
  end

  test "should create porcao" do
    assert_difference("Porcao.count") do
      post porcaos_url, params: { porcao: { custo: @porcao.custo, item_id: @porcao.item_id, peso_utilizado: @porcao.peso_utilizado } }
    end

    assert_redirected_to porcao_url(Porcao.last)
  end

  test "should show porcao" do
    get porcao_url(@porcao)
    assert_response :success
  end

  test "should get edit" do
    get edit_porcao_url(@porcao)
    assert_response :success
  end

  test "should update porcao" do
    patch porcao_url(@porcao), params: { porcao: { custo: @porcao.custo, item_id: @porcao.item_id, peso_utilizado: @porcao.peso_utilizado } }
    assert_redirected_to porcao_url(@porcao)
  end

  test "should destroy porcao" do
    assert_difference("Porcao.count", -1) do
      delete porcao_url(@porcao)
    end

    assert_redirected_to porcaos_url
  end
end
