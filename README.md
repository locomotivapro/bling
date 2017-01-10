# Ruby Bling API

Essa gem consiste em uma interface ruby para comunicação com a API do [Bling ERP](https://www.bling.com.br).

[![Code Climate](https://codeclimate.com/github/locomotivapro/bling/badges/gpa.svg)](https://codeclimate.com/github/locomotivapro/bling)
[![Test Coverage](https://codeclimate.com/github/locomotivapro/bling/badges/coverage.svg)](https://codeclimate.com/github/locomotivapro/bling/coverage)

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
users = Bling::API.users.list
```

*Cliente*

Listagem de todos clientes inseridos no Bling:

```ruby
user_client = Bling::API.users
users = user_client.list
```

Inserir um cliente no Bling:

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
