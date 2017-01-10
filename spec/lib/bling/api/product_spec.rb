require 'spec_helper'

describe Bling::API::Product do

  describe 'parsed hash' do
    it 'correctly parses it to template' do
      params = {
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
        max_quantity: 200,
        cest: ''
      }
      product = Bling::API::Product.new
      product.instance_variable_set(:@params, params)

      parsed_params = product.send :parsed_xml
      expect(parsed_params).to match(/Awesome/)
    end


    it 'works with the min required params' do
      params = {
        description: 'Awesome product',
        price: 20.50,
      }

      product = Bling::API::Product.new
      product.instance_variable_set(:@params, params)

      parsed_params = product.send :parsed_xml
      expect(parsed_params).to match(/20.5/)
    end
  end

end
