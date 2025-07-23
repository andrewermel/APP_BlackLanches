// Controlador Stimulus para gerenciar seleção de items em compras
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["itemSelect", "nome", "preco", "peso"];

  connect() {
    console.log("CompraForm controller connected");
  }

  itemChanged() {
    const itemId = this.itemSelectTarget.value;

    if (itemId) {
      this.suggestItemData(itemId);
    }
  }

  async suggestItemData(itemId) {
    try {
      const response = await fetch(`/compras/item_data/${itemId}`);
      const data = await response.json();

      if (response.ok) {
        // Apenas sugere os valores se os campos estiverem vazios
        if (!this.nomeTarget.value.trim()) {
          this.nomeTarget.value = data.nome;
        }
        if (!this.precoTarget.value || this.precoTarget.value == "0") {
          this.precoTarget.value = data.preco;
        }
        if (!this.pesoTarget.value || this.pesoTarget.value == "0") {
          this.pesoTarget.value = "1.0";
        }

        // Focus no campo nome para facilitar a edição da marca
        this.nomeTarget.focus();
        this.nomeTarget.select();
      } else {
        console.error("Erro ao buscar dados do item:", data.error);
      }
    } catch (error) {
      console.error("Erro na requisição:", error);
    }
  }
}
