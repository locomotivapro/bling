require 'spec_helper'

describe Bling::API::Invoice do
  let(:parsed_xml) { File.open(File.join(File.dirname(__FILE__), '../../../support/invoice_valid_xml.xml')).read }

  describe 'parsed hash' do
    it 'correctly parses it to template' do
      params = {
        type: 'E',
        ecommerce_order_number: '123',
        operation_type: 'Venda de Mercadorias',
        user: {
          name: 'Jonh Doe',
          tax_type: 'F',
          document: '35165478662',
          ie_rg: '306153420',
          tax_classification: 1,
          address: 'My great street',
          number: '33',
          neighborhood: 'Someplace',
          additional_address: 'apt 12',
          zipcode: '03454020',
          city: 'My city',
          state: 'SP',
          phone: '(11) 2233-3322',
          country: 'Brazil',
          email: 'jonh@@doe.com'
      },
      shipment: {
        carrier: 'Correios',
        document: '60120930390001',
        ie_rg: '306153420',
        full_address: 'My street, 33, apt 2',
        zipcode: '03454020',
        city: 'sao paulo',
        state: 'SP',
        vehicle_place: 'DMZ-0112',
        vehicle_state: 'SP',
        shipment_type: 'D',
        shipments_size: '',
        shipments_kind: '',
        number: '12342',
        raw_weight: 20,
        weight: 18,
        correios_service: 'Sedex',
        shipment_label_name: 'Jonh doe',
        shipment_label_address: 'Jonh doe street'
      },
      items: [
        { code: '001', type: 'P', description: 'lorem', unit: 'pc', item_quantity: 3, price: 12.30, origin: '0', tax_category: '1000.00.10'  },
        { code: '002', type: 'P', description: 'lorem', unit: 'pc', item_quantity: 4, price: 32.30, origin: '0', tax_category: '1000.00.10' },
      ],
      installments: [
        { days: '10', date: '28/06/2016', amount: 140.00, additional_info: '' },
        { days: '15', date: '28/07/2016', amount: 140.00, additional_info: '' },
      ],
      rural_reference_invoice_number: '001230',
      rural_reference_invoice_sequence: '0',
      rural_reference_invoice_date: '1202',
      shipment_amount: '10.00',
      ensurance_amount: '0.00',
      discount_amount: '0.00',
      expenses_amount: '2.50',
      additional_info: '',
      }


      invoice = Bling::API::Invoice.new
      parsed_params = invoice.send :parsed_xml, params
      expect(parsed_params).to eq(parsed_xml)
    end


    it 'works with the min required params'
  end

end
