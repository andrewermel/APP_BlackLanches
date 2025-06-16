json.extract! item, :id, :nome, :preco, :peso, :descricao, :categoria, :disponivel, :ativo, :created_at, :updated_at
json.url item_url(item, format: :json)
