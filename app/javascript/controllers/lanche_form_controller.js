import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["custoField", "precoField"];

  connect() {
    this.calcularCusto();
  }

  calcularCusto() {
    const quantidadeInputs = this.element.querySelectorAll(
      'input[name*="porcoes_com_quantidade"]'
    );
    let custoTotal = 0;

    quantidadeInputs.forEach((input) => {
      const quantidade = parseInt(input.value) || 0;
      const custo = parseFloat(input.dataset.custo) || 0;
      custoTotal += custo * quantidade;

      // Destacar visualmente porções com quantidade > 0
      const porcaoDiv = input.closest(".porcao-checkbox");
      if (quantidade > 0) {
        porcaoDiv.classList.add("has-quantity");
      } else {
        porcaoDiv.classList.remove("has-quantity");
      }
    });

    // Atualiza o campo de custo
    if (this.hasCustoFieldTarget) {
      this.custoFieldTarget.value = custoTotal.toFixed(2);
    }

    // Calcula e atualiza o preço sugerido (2x o custo)
    const precoSugerido = custoTotal * 2;
    if (this.hasPrecoFieldTarget) {
      this.precoFieldTarget.value = precoSugerido.toFixed(2);
    }

    // Atualiza contador visual de porções selecionadas
    this.atualizarContadorPorcoes(quantidadeInputs);
  }

  atualizarContadorPorcoes(quantidadeInputs) {
    let totalPorcoes = 0;
    let porcoesUnicas = 0;

    quantidadeInputs.forEach((input) => {
      const quantidade = parseInt(input.value) || 0;
      if (quantidade > 0) {
        totalPorcoes += quantidade;
        porcoesUnicas += 1;
      }
    });

    // Atualiza ou cria indicador visual
    let indicador = this.element.querySelector(".porcoes-contador");
    if (!indicador) {
      indicador = document.createElement("div");
      indicador.className = "porcoes-contador alert alert-info mt-2";
      const selecaoDiv = this.element.querySelector(".porcoes-selection");
      selecaoDiv.parentNode.insertBefore(indicador, selecaoDiv.nextSibling);
    }

    if (totalPorcoes > 0) {
      indicador.innerHTML = `<strong>Resumo:</strong> ${porcoesUnicas} tipo(s) de porção, total de ${totalPorcoes} unidade(s)`;
      indicador.style.display = "block";
    } else {
      indicador.style.display = "none";
    }
  }

  validatePhotos(event) {
    const files = event.target.files;

    // Calcular quantas fotos já existem
    const existingPhotos = this.element.querySelectorAll(
      ".existing-photos .col-md-4"
    ).length;
    const maxFiles = 3;
    const availableSlots = maxFiles - existingPhotos;

    if (files.length > availableSlots) {
      alert(
        `Você pode adicionar apenas ${availableSlots} foto(s) a mais. Você selecionou ${files.length} fotos.`
      );
      event.target.value = "";
      return;
    }

    // Validar tipos de arquivo
    const allowedTypes = ["image/jpeg", "image/jpg", "image/png", "image/gif"];
    let invalidFiles = [];

    Array.from(files).forEach((file) => {
      if (!allowedTypes.includes(file.type)) {
        invalidFiles.push(file.name);
      }
    });

    if (invalidFiles.length > 0) {
      alert(
        `Tipos de arquivo não permitidos: ${invalidFiles.join(
          ", "
        )}\nApenas JPG, PNG e GIF são aceitos.`
      );
      event.target.value = "";
      return;
    }

    // Validar tamanho dos arquivos (máximo 5MB por foto)
    const maxSize = 5 * 1024 * 1024; // 5MB
    let oversizedFiles = [];

    Array.from(files).forEach((file) => {
      if (file.size > maxSize) {
        oversizedFiles.push(file.name);
      }
    });

    if (oversizedFiles.length > 0) {
      alert(
        `Arquivos muito grandes (máximo 5MB): ${oversizedFiles.join(", ")}`
      );
      event.target.value = "";
      return;
    }

    this.showPhotoPreview(files);
  }

  showPhotoPreview(files) {
    const existingPreview = this.element.querySelector(".photo-preview");
    if (existingPreview) {
      existingPreview.remove();
    }

    if (files.length === 0) return;

    const previewContainer = document.createElement("div");
    previewContainer.className = "photo-preview mt-3";

    const title = document.createElement("h6");
    title.textContent = "Prévia das novas fotos:";
    previewContainer.appendChild(title);

    const previewGrid = document.createElement("div");
    previewGrid.className = "row";

    Array.from(files).forEach((file, index) => {
      const reader = new FileReader();
      reader.onload = (e) => {
        const col = document.createElement("div");
        col.className = "col-md-4 mb-2";

        const img = document.createElement("img");
        img.src = e.target.result;
        img.className = "img-thumbnail";
        img.style.cssText = "width: 100%; height: 150px; object-fit: cover;";

        const caption = document.createElement("div");
        caption.className = "text-center mt-1";
        caption.innerHTML = `<small>Nova foto ${index + 1}</small>`;

        col.appendChild(img);
        col.appendChild(caption);
        previewGrid.appendChild(col);
      };
      reader.readAsDataURL(file);
    });

    previewContainer.appendChild(previewGrid);

    // Inserir após o campo de upload
    const uploadField = this.element.querySelector('input[type="file"]');
    uploadField.parentNode.appendChild(previewContainer);
  }
}
