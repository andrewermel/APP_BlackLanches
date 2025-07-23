import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["itemSelect", "pesoUtilizado", "custo", "nomePorcao"];

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
    this.suggestNome();
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

    this.suggestNome();
  }

  suggestNome() {
    const itemId = this.itemSelectTarget.value;
    const pesoUtilizado = parseFloat(this.pesoUtilizadoTarget.value) || 0;

    if (itemId && this.itemsData[itemId] && pesoUtilizado > 0) {
      const nomeItem = this.itemsData[itemId].nome;
      let pesoText;

      if (pesoUtilizado >= 1) {
        pesoText = `${pesoUtilizado}kg`;
      } else {
        pesoText = `${(pesoUtilizado * 1000).toFixed(0)}g`;
      }

      const nomesSugeridos = [
        `${nomeItem} ${pesoText}`,
        `${nomeItem} para porção`,
        `Porção de ${nomeItem}`,
        `${nomeItem} processado`,
      ];

      // Se o campo nome estiver vazio, sugere o primeiro nome
      if (this.hasNomePorcaoTarget && !this.nomePorcaoTarget.value.trim()) {
        this.nomePorcaoTarget.value = nomesSugeridos[0];
        this.nomePorcaoTarget.setAttribute(
          "placeholder",
          `Sugestões: ${nomesSugeridos.slice(1, 3).join(", ")}`
        );
      }
    }
  }
}
