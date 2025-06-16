require "application_system_test_case"

class LanchesTest < ApplicationSystemTestCase
  setup do
    @lanch = lanches(:one)
  end

  test "visiting the index" do
    visit lanches_url
    assert_selector "h1", text: "Lanches"
  end

  test "should create lanch" do
    visit lanches_url
    click_on "New lanch"

    fill_in "Custo", with: @lanch.custo
    fill_in "Ingredientes", with: @lanch.ingredientes
    fill_in "Nome", with: @lanch.nome
    fill_in "Preco sugerido", with: @lanch.preco_sugerido
    click_on "Create Lanch"

    assert_text "Lanch was successfully created"
    click_on "Back"
  end

  test "should update Lanch" do
    visit lanch_url(@lanch)
    click_on "Edit this lanch", match: :first

    fill_in "Custo", with: @lanch.custo
    fill_in "Ingredientes", with: @lanch.ingredientes
    fill_in "Nome", with: @lanch.nome
    fill_in "Preco sugerido", with: @lanch.preco_sugerido
    click_on "Update Lanch"

    assert_text "Lanch was successfully updated"
    click_on "Back"
  end

  test "should destroy Lanch" do
    visit lanch_url(@lanch)
    click_on "Destroy this lanch", match: :first

    assert_text "Lanch was successfully destroyed"
  end
end
