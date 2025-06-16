# ⚖️ Sistema de Quantidades para Porções nos Lanches

## 🎯 Funcionalidade Implementada

### ✅ **Quantidades Personalizadas**

- **Múltiplas unidades** da mesma porção por lanche
- **Exemplo**: 2x "Carne 150g" em um único lanche
- **Flexibilidade total** para composição de lanches

### ✅ **Interface Intuitiva**

- **Campos numéricos** para definir quantidade (0-10)
- **Indicadores visuais** para porções selecionadas
- **Cálculo automático** de custos por quantidade
- **Contador em tempo real** de porções e unidades

## 🛠️ Implementação Técnica

### **Banco de Dados**

- **Nova coluna**: `quantidade` na tabela `lanche_porcaos`
- **Valor padrão**: 1 unidade
- **Validação**: Números inteiros maiores que 0

### **Modelo LanchePorcao**

```ruby
validates :quantidade, presence: true, numericality: {
  greater_than: 0, only_integer: true
}
```

### **Modelo Lanch - Cálculo de Custo**

```ruby
def total_custo
  lanche_porcaos.includes(:porcao).sum { |lp|
    (lp.porcao.custo || 0) * lp.quantidade
  }
end
```

### **Controller - Processamento de Quantidades**

- **Método**: `processar_porcoes_com_quantidade`
- **Parâmetros**: `porcoes_com_quantidade: { porcao_id => quantidade }`
- **Lógica**: Remove todas as porções antigas e adiciona as novas com quantidade

## 🎨 Interface do Usuário

### **Formulário de Lanche** (`/lanches/:id/edit`)

- **Layout atualizado** com campos de quantidade
- **Controles visuais**:
  - Informações da porção à esquerda
  - Campo de quantidade à direita
- **Feedback visual**: Destaque para porções com quantidade > 0

### **Visualização do Lanche** (`/lanches/:id`)

- **Badge azul** mostra quantidade quando > 1
- **Custo total** calculado automaticamente (quantidade × custo unitário)
- **Informações detalhadas**: peso unitário vs total

### **Listagem de Lanches** (`/lanches`)

- **Contador total**: "X unidade(s) (Y tipo(s))"
- **Lista detalhada**: "2x Carne 150g, 1x Queijo fatiado"

## 🎮 Como Usar

### **Criar Lanche com Quantidades**

1. Acesse `/lanches/new` ou `/lanches/:id/edit`
2. **Encontre a porção** desejada na lista
3. **Defina a quantidade** no campo numérico (ex: 2)
4. **Observe o destaque visual** da porção selecionada
5. **Veja o custo** sendo atualizado automaticamente
6. **Salve o lanche**

### **Exemplos Práticos**

- **Big Burger**: 2x "Carne 150g", 2x "Queijo fatiado", 1x "Alface"
- **Lanche Simples**: 1x "Carne 100g", 1x "Queijo"
- **Vegetariano**: 3x "Alface", 2x "Tomate", 1x "Queijo"

## 📊 Benefícios

### **Flexibilidade**

- 🍔 **Lanches personalizados** com quantidades variadas
- 📏 **Porcionamento preciso** por ingrediente
- 🔄 **Reutilização** de porções pré-definidas

### **Controle de Custos**

- 💰 **Cálculo automático** de custos totais
- 📊 **Visibilidade** de custo por unidade vs total
- 💡 **Preços sugeridos** baseados em quantidades reais

### **Experiência do Usuário**

- 👁️ **Interface clara** e intuitiva
- ⚡ **Feedback imediato** durante composição
- 📱 **Design responsivo** para mobile

## 🔧 Funcionalidades Avançadas

### **Validações Inteligentes**

- **Quantidade mínima**: 1 unidade
- **Quantidade máxima**: 10 unidades (configurável)
- **Números inteiros** apenas
- **Remoção automática** quando quantidade = 0

### **Cálculos Dinâmicos**

- **JavaScript em tempo real** para custos
- **Contador visual** de porções selecionadas
- **Destaque automático** de porções ativas

### **Compatibilidade**

- **Dados existentes** migrados automaticamente
- **Lanches antigos** funcionam normalmente
- **Valor padrão** = 1 para porções existentes

## 🎯 Cenários de Uso

### **Lanchonete Tradicional**

```
Big Mac Caseiro:
- 2x Carne 150g (hambúrguer duplo)
- 2x Queijo fatiado
- 1x Alface
- 1x Molho especial
```

### **Restaurante**

```
Sanduíche Gourmet:
- 1x Carne 200g (porção maior)
- 3x Queijo artesanal (extra queijo)
- 2x Rúcula (porção generosa)
```

### **Food Truck**

```
Combo Econômico:
- 1x Carne 100g (porção padrão)
- 1x Queijo simples
- 2x Alface (enchimento)
```

## 🚀 Próximas Melhorias

### **Sugestões Futuras**

- **Templates** de quantidades por tipo de lanche
- **Histórico** das combinações mais usadas
- **Variações sazonais** automáticas
- **Alertas** de estoque baseados em quantidades

### **Relatórios**

- **Consumo** de ingredientes por quantidade
- **Lanches mais populares** por composição
- **Análise de custos** por quantidade de porções
