# 🍔 BlackLanches - Sistema de Gestão de Lanches

**BlackLanches** é uma aplicação web desenvolvida em Ruby on Rails para gerenciar ingredientes, compras, porções e criação de lanches de forma eficiente. O sistema permite controlar custos, calcular preços sugeridos e acompanhar o estoque de ingredientes.

## 📋 Funcionalidades

### 🛒 **Gestão de Compras**

- Registrar compras de ingredientes
- Atualização automática de preços médios
- Controle de data de compra e peso
- Validação de itens disponíveis

### 📦 **Controle de Ingredientes**

- Cadastro de itens com categoria, preço e peso
- Status de ativo/inativo e disponível/indisponível
- Cálculo automático de preços médios baseado nas compras
- Validação de dados de entrada

### ⚖️ **Gestão de Porções**

- Definir porções específicas de cada ingrediente
- Cálculo automático de custo por porção
- Peso utilizado personalizável
- Integração com o sistema de lanches

### 🥪 **Criação de Lanches**

- Composição de lanches usando múltiplas porções
- Cálculo automático do custo total
- Sugestão de preço de venda (margem de 100%)
- Relacionamento many-to-many com porções

### 👤 **Autenticação**

- Sistema de usuários com Devise
- Login, registro e recuperação de senha
- Sessões persistentes

## 🛠️ Tecnologias Utilizadas

- **Ruby** 3.x
- **Rails** 8.0.2
- **PostgreSQL** - Banco de dados
- **Devise** - Autenticação
- **Turbo Rails** - SPA-like experience
- **Stimulus** - JavaScript framework
- **Importmap** - Asset pipeline moderno
- **Puma** - Web server
- **Docker** - Containerização

## 🗄️ Estrutura do Banco de Dados

```
Users (Devise)
├── Items (Ingredientes)
│   ├── Compras (Histórico de compras)
│   └── Porcaos (Porções utilizadas)
│       └── LanchePorcaos (Join table)
│           └── Lanches (Produtos finais)
```

## 🚀 Como Executar

### Pré-requisitos

- Ruby 3.x
- PostgreSQL
- Node.js (para assets)
- Docker (opcional)

### Instalação Local

1. **Clone o repositório:**

```bash
git clone <url-do-repositorio>
cd App_BlackLanches
```

2. **Instale as dependências:**

```bash
bundle install
```

3. **Configure o banco de dados:**

```bash
# Edite config/database.yml com suas credenciais PostgreSQL
rails db:create
rails db:migrate
rails db:seed
```

4. **Execute a aplicação:**

```bash
rails server
```

5. **Acesse no navegador:**

```
http://localhost:3000
```

### Usando Docker

```bash
# Build da imagem
docker build -t blacklanches .

# Execute o container
docker run -p 3000:3000 blacklanches
```

## 📊 Modelos e Relacionamentos

### **User**

- Autenticação com Devise
- Campos: email, password, etc.

### **Item** (Ingredientes)

- `nome`: Nome do ingrediente
- `preco`: Preço por kg
- `peso`: Peso padrão
- `categoria`: Categoria do item
- `ativo`: Se está ativo no sistema
- `disponivel`: Se está disponível para uso

### **Compra**

- `nome`: Nome da compra
- `preco`: Preço pago
- `peso`: Peso comprado
- `data_compra`: Data da compra
- `item_id`: Referência ao item

### **Porcao**

- `peso_utilizado`: Quantidade do ingrediente
- `custo`: Custo calculado da porção
- `item_id`: Referência ao item

### **Lanch**

- `nome`: Nome do lanche
- Relacionamento many-to-many com Porcaos

### **LanchePorcao** (Join Table)

- `lanch_id`: ID do lanche
- `porcao_id`: ID da porção

## 🧪 Testes

Execute os testes com:

```bash
# Todos os testes
rails test

# Testes específicos
rails test test/models/
rails test test/controllers/
rails test test/system/
```

## 📈 Funcionalidades de Negócio

### Cálculo Automático de Custos

- **Compras**: Atualiza automaticamente o preço médio dos itens
- **Porções**: Calcula o custo baseado no peso utilizado e preço do item
- **Lanches**: Soma automaticamente o custo de todas as porções

### Validações Implementadas

- **Items**: Nome, preço, peso e categoria obrigatórios
- **Compras**: Validação de item disponível e dados válidos
- **Porções**: Peso utilizado obrigatório e positivo
- **Lanches**: Nome obrigatório

### Callbacks e Automações

- Atualização automática de preços médios após compras
- Recálculo de custos quando porções são alteradas
- Cópia automática de dados do item para compras

## 🔧 Configuração de Ambiente

### Desenvolvimento

```ruby
# config/environments/development.rb
# Configurações para desenvolvimento local
```

### Produção

```ruby
# config/environments/production.rb
# Configurações otimizadas para produção
```

## 📝 Scripts Úteis

```bash
# Setup inicial
bin/setup

# Console Rails
bin/rails console

# Gerar migrações
bin/rails generate migration NomeDaMigracao

# Executar RuboCop
bin/rubocop

# Análise de segurança
bin/brakeman
```

## 🐳 Docker

O projeto inclui configuração Docker para facilitar o deployment:

- `Dockerfile`: Configuração da imagem
- `.dockerignore`: Arquivos ignorados no build

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## 📞 Suporte

Para dúvidas ou suporte, entre em contato através dos issues do GitHub.
