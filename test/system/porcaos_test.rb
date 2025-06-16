require "application_system_test_case"

class PorcaosTest < ApplicationSystemTestCase
  setup do
    @porcao = porcaos(:one)
  end

  test "visiting the index" do
    visit porcaos_url
    assert_selector "h1", text: "Porcaos"
  end

  test "should create porcao" do
    visit porcaos_url
    click_on "New porcao"

    fill_in "Custo", with: @porcao.custo
    fill_in "Item", with: @porcao.item_id
    fill_in "Peso utilizado", with: @porcao.peso_utilizado
    click_on "Create Porcao"

    assert_text "Porcao was successfully created"
    click_on "Back"
  end

  test "should update Porcao" do
    visit porcao_url(@porcao)
    click_on "Edit this porcao", match: :first

    fill_in "Custo", with: @porcao.custo
    fill_in "Item", with: @porcao.item_id
    fill_in "Peso utilizado", with: @porcao.peso_utilizado
    click_on "Update Porcao"

    assert_text "Porcao was successfully updated"
    click_on "Back"
  end

  test "should destroy Porcao" do
    visit porcao_url(@porcao)
    click_on "Destroy this porcao", match: :first

    assert_text "Porcao was successfully destroyed"
  end
end
