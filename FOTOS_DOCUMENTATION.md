# 📷 Funcionalidade de Fotos para Lanches - BlackLanches

## 🎯 Funcionalidades Implementadas

### ✅ **Listagem de Lanches** (`/lanches`)

- Mostra apenas a **primeira foto** de cada lanche
- Indica quantas fotos adicionais existem com badge "+X fotos"
- Fallback elegante quando não há fotos disponíveis

### ✅ **Visualização Completa** (`/lanches/:id`)

- Exibe **todas as fotos** do lanche em uma galeria
- Modal para visualizar fotos em tamanho maior
- Layout responsivo em grid de 3 colunas

### ✅ **Upload de Fotos**

- Máximo de **3 fotos por lanche**
- Validação de tipos de arquivo (JPG, PNG, GIF)
- Validação de tamanho (máximo 5MB por foto)
- Preview das fotos antes do upload

### ✅ **Gerenciamento de Fotos**

- **Adicionar fotos** sem substituir as existentes
- **Remover fotos individuais** com confirmação
- Indicador visual do limite de fotos
- Contador de fotos atual vs máximo

## 🛠️ Arquivos Modificados

### **Models**

- `app/models/lanch.rb`: Adicionado `has_many_attached :fotos` e validação de máximo 3 fotos

### **Controllers**

- `app/controllers/lanches_controller.rb`:
  - Método `adicionar_fotos_ao_lanche` para preservar fotos existentes
  - Ação `remove_photo` para remoção individual
  - Validação de limite de fotos

### **Routes**

- `config/routes.rb`: Adicionada rota para remoção de fotos individuais

### **Views**

- `app/views/lanches/index.html.erb`: Exibição da primeira foto com contador
- `app/views/lanches/show.html.erb`: Galeria completa com modal
- `app/views/lanches/_form.html.erb`: Upload com preview e remoção individual

### **JavaScript**

- `app/javascript/controllers/lanche_form_controller.js`: Validação client-side e preview

### **Styles**

- `app/assets/stylesheets/application.css`: Estilos para galeria, botões e indicadores

## 🔧 Dependências

### **Gems Adicionadas**

```ruby
gem "image_processing", "~> 1.2"
```

### **Active Storage**

- Migrações executadas para tabelas de anexos
- Configuração local para desenvolvimento

## 🎮 Como Usar

### **Adicionar Fotos**

1. Ao criar/editar um lanche
2. Selecione até 3 arquivos de imagem
3. Preview automático será exibido
4. Salve o formulário

### **Remover Fotos**

1. No formulário de edição
2. Clique no ✖️ vermelho sobre a foto
3. Confirme a remoção

### **Visualizar Fotos**

1. Na listagem: apenas primeira foto
2. Na página do lanche: todas as fotos
3. Clique na foto para modal ampliado

## 🛡️ Validações Implementadas

### **Server-side**

- Máximo 3 fotos por lanche
- Tipo de arquivo válido
- Tamanho do arquivo

### **Client-side**

- Validação instantânea de limite
- Preview antes do upload
- Feedback visual de erros

## 🐛 Troubleshooting

### **Fotos não aparecem**

- Verificar se Active Storage está configurado
- Confirmar que migrações foram executadas
- Verificar permissões da pasta `storage/`

### **Erro de upload**

- Verificar tamanho do arquivo (< 5MB)
- Confirmar tipo de arquivo (JPG, PNG, GIF)
- Verificar limite de 3 fotos

### **Performance**

- Fotos são redimensionadas automaticamente
- Cache de imagens ativo
- Lazy loading implementado
