import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["itemSelect", "pesoUtilizado", "custo"];

  connect() {
    this.itemsData = {};
    this.loadItemsData();
  }

  async loadItemsData() {
    try {
      const response = await fetch("/items.json");
      const items = await response.json();

      items.forEach((item) => {
        this.itemsData[item.id] = {
          nome: item.nome,
          preco: parseFloat(item.preco),
        };
      });
    } catch (error) {
      console.error("Erro ao carregar dados dos items:", error);
    }
  }

  updatePreco() {
    this.calculateCusto();
  }

  calculateCusto() {
    const itemId = this.itemSelectTarget.value;
    const pesoUtilizado = parseFloat(this.pesoUtilizadoTarget.value) || 0;

    if (itemId && this.itemsData[itemId] && pesoUtilizado > 0) {
      const precoItem = this.itemsData[itemId].preco;
      const custo = precoItem * pesoUtilizado;

      this.custoTarget.value = custo.toFixed(2);
    } else {
      this.custoTarget.value = "";
    }
  }
}
