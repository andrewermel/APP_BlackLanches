import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["custoField", "precoField"];

  connect() {
    this.calcularCusto();
  }

  calcularCusto() {
    const checkboxes = this.element.querySelectorAll(
      'input[name="lanch[porcao_ids][]"]:checked'
    );
    let custoTotal = 0;

    checkboxes.forEach((checkbox) => {
      const custo = parseFloat(checkbox.dataset.custo) || 0;
      custoTotal += custo;
    });

    // Atualiza o campo de custo
    this.custoFieldTarget.value = custoTotal.toFixed(2);

    // Calcula e atualiza o preço sugerido (2x o custo)
    const precoSugerido = custoTotal * 2;
    this.precoFieldTarget.value = precoSugerido.toFixed(2);
  }
}
