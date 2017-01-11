# Ruby Bling API

Interface ruby para comunicação com a API do [Bling ERP](https://www.bling.com.br).

## Atenção, gem em desenvolvimento, nem todas as chamadas esto disponíveis ainda.

[![Code Climate](https://codeclimate.com/github/locomotivapro/bling/badges/gpa.svg)](https://codeclimate.com/github/locomotivapro/bling)
[![Test Coverage](https://codeclimate.com/github/locomotivapro/bling/badges/coverage.svg)](https://codeclimate.com/github/locomotivapro/bling/coverage)
[![Build Status](https://semaphoreci.com/api/v1/locomotiva/bling/branches/master/badge.svg)](https://semaphoreci.com/locomotiva/bling)

Documentação Rdoc em [Rubydoc.info](http://www.rubydoc.info/gems/bling-ruby-api/)

## Configuração

Instale a versão mais recente

```
$ gem install bling
```

Configure sua chave de integração:

```ruby
Bling::Config.api_key = '55fxs324dsk3....'
```

Por padrão a gem é configurada para aceitar os parâmetros em inglês,
caso deseje é possível configurar a gem para aceitar em português:

```ruby
Bling::Config.default_language= :pt # :en default
```

## Uso

A chamada para os possíveis endpoints da API do Bling são todas feitas
utilizando a class Bling::API ex:

```ruby
users = Bling::API.user.list
```

Toda chamada retorna um objeto da class Bling::API::Response ([métodos disponíveis](http://www.rubydoc.info/gems/bling-ruby-api/Bling/API/Response)). Um método importante de instâncias desta classe é o método records, em caso de sucesso da consulta, este método retornará uma array contendo os registros obtidos:

```ruby
user_request = Bling::API.user.get('36434...')
user_request.records # [Record]
```

Cada item retornado em uma chamada é inserido em um objeto da classe Bling::API::Record, responsável por criar readers para cada um dos valores retornados, ex:

```ruby
user_request = Bling::API.user.get('36434...')
user = user_request.records.first

# Ao invés de consultar como um Hash (ex: user['name']) é possível fazer:

user.name # => 'Denis'
```

## Chamadas disponíveis

*Cliente*

- Listagem de todos clientes inseridos no Bling:

```ruby
user_client = Bling::API.user.list

if user_client.success?
  users = user_client.records
end
```

- Inserir um cliente no Bling:

```ruby
user = Bling::API.user.create(
  {
  name: 'Jonh Doe',
  company_name: '',
  tax_type: 1,
  document: '35165478662',
  ir_rg: '306153420',
  address: 'My great street',
  number: '33',
  additional_address: 'apt 12',
  zipcode: '03454020',
  city: 'Sao Paulo',
  uf: 'SP',
  phone: '(11) 2233-3322',
  email: jonh@@doe.com'
  }
)

```

- Obter dados de um cliente

```ruby
user = Bling::API.user.get(user_id) # user_id: cpf ou cnpj
```
*Produto*

- Listar produtos

```ruby
products_client = Bling::API.user.list

if products_client.success?
  products = products_client.records
end
```

- Inserir um produto

```ruby
product = Bling::API.product.create(
  {
  code: '92314',
  description: 'Awesome product',
  additional_description: 'In lovely colors',
  unit: 'Pc',
  price: 20.50,
  cost_price: 14.30,
  raw_weight: 2,
  weight: 1.8,
  tax_category: '1000.01.01',
  origin: 0,
  quantity: 10,
  gtin: 832222,
  gtin_package: 13414,
  width: 25,
  height: 15,
  depth: 10,
  min_quantity: 1,
  max_quantity: 200
  }
)
```

- Obter informaçes de um produto

```ruby
product_client = Bling::API.product.get('92314')
product = product_client.records.first
```

- Atualizar um produto
```ruby
params = {
  description: 'Awesome product',
  additional_description: 'In lovely colors',
  unit: 'Pc',
  price: 20.50,
  cost_price: 14.30,
  raw_weight: 2,
  weight: 1.8,
  tax_category: '1000.01.01',
  origin: 0,
  quantity: 10,
  gtin: 832222,
  gtin_package: 13414,
  width: 25,
  height: 15,
  depth: 10,
  min_quantity: 1,
  max_quantity: 200
 }

product = Bling::API.product.update('92314', params)
```

- Remover um produto
```ruby
Bling::API.product.delete('92314')
```

*Pedido*

- Listar pedidos
```ruby
order_request = Bling::API.order.list
orders = order_request.records if order_request.success?
```

- Inserir um pedido
```ruby
order = Bling::API.order.create(
  {
  order_number: '123',
  ecommerce_order_number: '55123',
  store: 'Foo',
  selling_category: '',
  user: {
   name: 'Jonh Doe',
   company_name: '',
   tax_type: 1,
   document: '35165478662',
   ir_rg: '306153420',
   tax_classification: 1,
   address: 'My great street',
   number: '33',
   additional_address: 'apt 12',
   zipcode: '03454020',
   city: 'Sao Paulo',
   uf: 'SP',
   phone: '(11) 2233-3322',
   cellphone: '(11) 2233-3322',
   email: jonh@@doe.com'
  },
  shipment: {
    carrier: 'Correios',
    shipment_type: 'R'
    shipment_label: {}
  },
  items: [
    { code: '001', description: 'lorem', unit: 'pc', item_quantity: 3, price: 12.30 },
    { code: '002', description: 'lorem', unit: 'pc', item_quantity: 4, price: 32.30 },
  ],
  installments: [
    { date: '28/06/2016', amount: 140.00, additional_info: '' },
    { date: '28/07/2016', amount: 140.00, additional_info: '' },
  ],
  shipment_amount: 10.0,
  discount_amount: 0.0,
  additional_info: '',
  private_additional_info: ''
  }
)
```

- Obter informaçes de um pedido

```ruby
order_client = Bling::API.order.get('123')
product = order_client.records.first
```

- Alterar status do pedido
```ruby
# Status disponíveis:
# - 0 (Em Aberto)
# - 1 (Atendido)
# - 2 (Cancelado)
# - 3 (Em Andamento)
# - 4 (Venda Agenciada)
# - 10 (Em Digitação)
# - 11 (Verificado)

Bling::API.order.put('123', 3)
```

## Desenvolvimento

Desenvolvido e mantido por [Locomotiva.pro](http://locomotiva.pro), copyright (c) 2013-2016.
