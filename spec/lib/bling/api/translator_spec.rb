require 'spec_helper'

describe Bling::API::Translator do

  describe '#translate_url' do
    it 'accepts a Symbol as key'  do
      expect(described_class.translate_url(:product)).to eq 'produto'
    end

    it 'accepts a String as key' do
      expect(described_class.translate_url('product')).to eq 'produto'
    end

    it 'return a nested id if passed' do
      expect(described_class.translate_url(:product, id: 1)).to eq 'produto/1'
    end

    it 'accepts anything as id' do
      expect(described_class.translate_url(:product, id: 'foobar')).to eq 'produto/foobar'
    end
  end

  describe '#translate_hash' do
    context 'to en' do
      let(:response) { { code: '001', description: 'Awesome thing' } }

      it 'translate a hash of Symbol keys' do
        params = { codigo: '001', descricao: 'Awesome thing' }
        expect(described_class.translate_hash(params)).to eq response
      end

      it 'converts non-snakecase to snakecase' do
        params = { 'pesoBruto' => '1', descricao: 'Awesome thing' }
        response = { :raw_weight => '1', description: 'Awesome thing' }
        expect(described_class.translate_hash(params)).to eq response
      end

      it 'accepts Strings and Symbols as keys' do
        params = { 'codigo' => '001', descricao: 'Awesome thing' }
        expect(described_class.translate_hash(params)).to eq response
      end

      it 'recursively translate hashes and arrays' do
        params = { resultado: { produtos: [{codigo: '001'}, {codigo: '002'}] }  }
        result = { result: { products: [{code: '001'}, {code: '002'}] }  }
        expect(described_class.translate_hash(params)).to eq result
      end

      it 'keeps keys missing on yml' do
        params = { codigo:  '001', nao_existente: 'foo'  }
        result = { code:  '001', nao_existente: 'foo'  }
        expect(described_class.translate_hash(params)).to eq result
      end
    end

    context 'to pt' do
      let(:response) { { codigo: '001', descricao: 'Awesome thing' } }

      it 'translate a hash of Symbol keys' do
        params = { code: '001', description: 'Awesome thing' }
        expect(described_class.translate_hash(params, to: :pt)).to eq response
      end

      it 'accepts Strings and Symbols as keys' do
        params = { 'code' => '001', description: 'Awesome thing' }
        expect(described_class.translate_hash(params, to: :pt)).to eq response
      end

      it 'recursively translate hashes and arrays' do
        params = { result: { products: [{code: '001'}, {code: '002'}] }  }
        result = { resultado: { produtos: [{codigo: '001'}, {codigo: '002'}] }  }
        expect(described_class.translate_hash(params, to: :pt)).to eq result
      end

      it 'keeps keys missing on yml' do
        params = { code:  '001', nao_existente: 'foo'  }
        result = { codigo:  '001', nao_existente: 'foo'  }
        expect(described_class.translate_hash(params, to: :pt)).to eq result
      end
    end
  end

end
