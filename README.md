# 🍔 BlackLanches - Sistema de Gestão para Lanchonetes

[![Rails Version](https://img.shields.io/badge/Rails-8.0.2-red.svg)](https://rubyonrails.org/)
[![Ruby Version](https://img.shields.io/badge/Ruby-3.3.0-red.svg)](https://www.ruby-lang.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue.svg)](https://www.postgresql.org/)
[![Test Coverage](https://img.shields.io/badge/Test%20Coverage-90.53%25-brightgreen.svg)](https://github.com/andrewermel/APP_BlackLanches)
[![RuboCop](https://img.shields.io/badge/RuboCop-Passing-brightgreen.svg)](https://rubocop.org/)

Sistema completo de gestão para lanchonetes desenvolvido em Ruby on Rails, oferecendo controle total sobre ingredientes, porções, lanches e compras com interface intuitiva e sistema internacional.

## 🚀 Funcionalidades

### � Gestão de Ingredientes
- ✅ Cadastro completo de ingredientes (nome, categoria, peso, preço)
- ✅ Controle de disponibilidade e status
- ✅ Cálculo automático de custos baseado em compras
- ✅ Filtros por categoria e disponibilidade

### 🍽️ Sistema de Porções
- ✅ Criação de porções personalizadas por peso
- ✅ Cálculo automático de custos das porções
- ✅ Relacionamento inteligente com ingredientes
- ✅ Gerenciamento de quantidade utilizada

### 🍔 Menu de Lanches
- ✅ Criação de lanches com múltiplas porções
- ✅ Upload de até 3 fotos por lanche
- ✅ Cálculo automático de custo total
- ✅ Sugestão de preço baseada no custo
- ✅ Sistema de reordenação (drag & drop com botões)
- ✅ Controle de margem de lucro

### 🛒 Controle de Compras
- ✅ Registro de compras de ingredientes
- ✅ Atualização automática de preços médios
- ✅ Histórico completo de compras
- ✅ Impacto automático nos custos dos lanches

### 🌍 Sistema Internacional
- ✅ **Multi-idioma**: Português (pt-BR) e English (en)
- ✅ **Multi-moeda**: Real (R$) e Dólar ($)
- ✅ **Timezone**: Brasília configurado
- ✅ **Seletor de idioma**: Bandeiras clicáveis 🇧🇷🇺🇸

### � Autenticação & Segurança
- ✅ Sistema de login completo (Devise)
- ✅ Proteção CSRF em todas as operações
- ✅ Strong Parameters
- ✅ Validações robustas

## 🛠️ Tecnologias

- **Backend**: Ruby 3.3.0, Rails 8.0.2
- **Database**: PostgreSQL 13+
- **Frontend**: Hotwire (Turbo + Stimulus), Bootstrap 5
- **Upload**: Active Storage
- **Auth**: Devise
- **Tests**: RSpec, FactoryBot, Capybara
- **Quality**: RuboCop, Brakeman, SimpleCov
- **Deploy**: Kamal, Docker, Thruster

## � Instalação

### Pré-requisitos
- Ruby 3.3.0+
- PostgreSQL 13+
- Node.js 18+ (para Importmap)
- Git

### 1. Clone o repositório
```bash
git clone https://github.com/andrewermel/APP_BlackLanches.git
cd APP_BlackLanches
```

### 2. Configure as variáveis de ambiente
```bash
cp .env.example .env
# Edite o arquivo .env com suas configurações
```

### 3. Instale as dependências
```bash
bundle install
```

### 4. Configure o banco de dados
```bash
rails db:create
rails db:migrate
rails db:seed  # Dados de exemplo (opcional)
```

### 5. Inicie o servidor
```bash
rails server
```

Acesse: http://localhost:3000

## 🧪 Testes

### Executar todos os testes
```bash
rspec
```

### Executar com cobertura
```bash
rspec --format documentation
```

### Executar análise de código
```bash
rubocop
brakeman
```

**🏆 Status dos Testes:**
- ✅ **220 testes passando**
- ✅ **90.53% de cobertura**
- ✅ **0 violações RuboCop**
- ✅ **0 problemas de segurança**

## 📊 Estrutura do Banco

### Tabelas Principais
- `users` - Usuários do sistema
- `items` - Ingredientes disponíveis
- `porcaos` - Porções dos ingredientes
- `lanches` - Produtos finais (hambúrgueres)
- `lanche_porcaos` - Relacionamento lanches ↔ porções
- `compras` - Histórico de compras

### Relacionamentos
```ruby
User (Devise)
├── Items (ingredientes)
│   ├── Porcaos (peso/custo)
│   └── Compras (histórico)
└── Lanches (produtos)
    ├── LanchePorcaos (N:M)
    └── Active Storage (fotos)
```

## 🌟 Destaques do Código

### ✅ **Qualidade Excepcional**
- Models com validações robustas
- Controllers seguindo padrões REST
- Views organizadas com partials
- Helpers reutilizáveis
- Testes abrangentes (90%+ cobertura)

### ✅ **Performance Otimizada**
- Eager loading (`includes`) para evitar N+1
- Scopes otimizados
- Indexes estratégicos
- Callbacks eficientes

### ✅ **Segurança em Primeiro Lugar**
- Proteção CSRF ativa
- Strong Parameters validados
- Validações de upload
- Sanitização de dados

### ✅ **Experiência Internacional**
- Sistema I18n completo
- Formatação de moeda dinâmica
- Timezone configurado
- Interface responsiva

## 📈 Métricas

- **📝 Linhas de código**: 4.379
- **🧪 Testes**: 220 specs
- **� Cobertura**: 90.53%
- **🔍 Qualidade**: 0 violações
- **🚀 Performance**: Otimizado
- **🌍 Idiomas**: 2 (pt-BR, en)

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Crie um Pull Request

## 👨‍� Autor

**Andrew Ermel**
- GitHub: [@andrewermel](https://github.com/andrewermel)

---

**🍔 BlackLanches - Desenvolvido com ❤️ em Ruby on Rails**

*Sistema profissional para gestão completa de lanchonetes*
