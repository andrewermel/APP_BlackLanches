# 🚀 BlackLanches - Deployment Guide

Este guia fornece instruções completas para fazer deploy da aplicação BlackLanches em diferentes ambientes.

## 📋 Pré-requisitos

- Docker & Docker Compose
- Ruby 3.3.0+
- PostgreSQL 13+
- Domínio configurado (para produção)
- Certificado SSL

## 🔧 Configuração de Ambiente

### 1. Variáveis de Ambiente

Copie e configure o arquivo de ambiente:

```bash
cp .env.example .env
```

Configure as variáveis obrigatórias:

```env
# Database
DATABASE_HOST=your_db_host
DATABASE_USERNAME=your_db_user
DATABASE_PASSWORD=secure_password
DATABASE_NAME_PRODUCTION=blacklanches_production

# Rails
SECRET_KEY_BASE=$(rails secret)
RAILS_ENV=production

# Security
SENTRY_DSN=your_sentry_dsn
```

### 2. Secrets e Credenciais

Gere uma nova secret key:

```bash
rails secret
```

Configure as credenciais Rails:

```bash
EDITOR=nano rails credentials:edit
```

## 🐳 Deploy com Docker

### 1. Build da Imagem

```bash
docker build -t blacklanches:latest .
```

### 2. Docker Compose (Recomendado)

Crie `docker-compose.production.yml`:

```yaml
version: '3.8'

services:
  db:
    image: postgres:13
    environment:
      POSTGRES_DB: blacklanches_production
      POSTGRES_USER: ${DATABASE_USERNAME}
      POSTGRES_PASSWORD: ${DATABASE_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  app:
    image: blacklanches:latest
    depends_on:
      - db
    environment:
      - DATABASE_HOST=db
      - DATABASE_NAME_PRODUCTION=blacklanches_production
      - DATABASE_USERNAME=${DATABASE_USERNAME}
      - DATABASE_PASSWORD=${DATABASE_PASSWORD}
      - SECRET_KEY_BASE=${SECRET_KEY_BASE}
      - RAILS_ENV=production
    ports:
      - "3000:3000"
    restart: unless-stopped
    command: >
      bash -c "
        rails db:create RAILS_ENV=production &&
        rails db:migrate RAILS_ENV=production &&
        rails assets:precompile &&
        rails server -b 0.0.0.0 -p 3000 -e production
      "

volumes:
  postgres_data:
```

### 3. Executar

```bash
docker-compose -f docker-compose.production.yml up -d
```

## ☁️ Deploy com Kamal (Recomendado)

A aplicação já está configurada para Kamal. Configure o `config/deploy.yml`:

```yaml
service: blacklanches
image: blacklanches

servers:
  - your.server.ip

registry:
  server: your.registry.com
  username: your_username
  password: your_password

env:
  clear:
    RAILS_ENV: production
  secret:
    - SECRET_KEY_BASE
    - DATABASE_PASSWORD
```

Execute o deploy:

```bash
kamal setup
kamal deploy
```

## 🌐 Deploy em VPS/Servidor

### 1. Preparar o Servidor

```bash
# Instalar dependências
sudo apt update
sudo apt install -y ruby-dev postgresql postgresql-contrib nodejs npm nginx

# Instalar RVM
curl -sSL https://get.rvm.io | bash
rvm install 3.3.0
rvm use 3.3.0 --default

# Instalar Bundler
gem install bundler
```

### 2. Configurar PostgreSQL

```bash
sudo -u postgres createuser -s blacklanches
sudo -u postgres createdb blacklanches_production
sudo -u postgres psql -c "ALTER USER blacklanches PASSWORD 'secure_password';"
```

### 3. Deploy da Aplicação

```bash
# Clone do repositório
git clone https://github.com/your-user/APP_BlackLanches.git
cd APP_BlackLanches

# Instalar dependências
bundle install --without development test
npm install

# Configurar banco
RAILS_ENV=production rails db:create
RAILS_ENV=production rails db:migrate

# Compilar assets
RAILS_ENV=production rails assets:precompile

# Iniciar servidor
RAILS_ENV=production rails server -p 3000
```

### 4. Configurar Nginx

Crie `/etc/nginx/sites-available/blacklanches`:

```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Ativar o site:

```bash
sudo ln -s /etc/nginx/sites-available/blacklanches /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 🔒 SSL com Let's Encrypt

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

## 📊 Monitoramento

### 1. Configurar Sentry

Adicione ao Gemfile:

```ruby
gem 'sentry-rails'
gem 'sentry-ruby'
```

Configure em `config/initializers/sentry.rb`:

```ruby
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 0.1
end
```

### 2. Health Check

A aplicação já possui endpoint de health check em `/health`.

## 🔄 CI/CD com GitHub Actions

Crie `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:13
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
    - uses: actions/checkout@v3
    
    - uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.3.0
        bundler-cache: true
    
    - name: Run tests
      run: |
        bundle exec rails db:create RAILS_ENV=test
        bundle exec rails db:migrate RAILS_ENV=test
        bundle exec rspec
        
    - name: Run RuboCop
      run: bundle exec rubocop
      
    - name: Run Brakeman
      run: bundle exec brakeman

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy with Kamal
      run: |
        # Configure Kamal deployment
        # kamal deploy
```

## 📋 Checklist de Deploy

### Antes do Deploy
- [ ] Configurar variáveis de ambiente
- [ ] Testar aplicação localmente
- [ ] Executar todos os testes
- [ ] Verificar RuboCop e Brakeman
- [ ] Configurar domínio e DNS
- [ ] Preparar certificado SSL

### Após o Deploy
- [ ] Verificar logs da aplicação
- [ ] Testar funcionalidades principais
- [ ] Configurar monitoramento
- [ ] Configurar backups do banco
- [ ] Documentar credenciais de acesso

## 🛠️ Comandos Úteis

```bash
# Logs da aplicação
docker-compose logs -f app

# Acesso ao console Rails
docker-compose exec app rails console

# Backup do banco
pg_dump blacklanches_production > backup.sql

# Restaurar backup
psql blacklanches_production < backup.sql

# Monitorar recursos
docker stats
```

## 🆘 Troubleshooting

### Problemas Comuns

1. **Erro de conexão com banco**
   - Verificar credenciais no `.env`
   - Testar conexão: `psql -h host -U user -d database`

2. **Assets não carregando**
   - Recompilar: `rails assets:precompile`
   - Verificar configuração do nginx

3. **Erro 500**
   - Verificar logs: `tail -f log/production.log`
   - Verificar configuração do Sentry

4. **Performance lenta**
   - Verificar queries N+1
   - Analisar logs do banco
   - Implementar cache Redis

## 📞 Suporte

Para problemas de deploy, abra uma issue no GitHub ou entre em contato:

- **GitHub**: [Issues](https://github.com/your-user/APP_BlackLanches/issues)
- **Email**: support@blacklanches.com

---

**🚀 Boa sorte com o deploy!**
