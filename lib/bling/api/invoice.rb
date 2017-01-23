module Bling
  module API
    # This class is used to make requests to all available
    # actions related to invoices in Bling api. Is strongly recommended
    # to use the Bling::API module wrapper
    #
    class Invoice < Request
      # Get a list of available invoices
      #
      # @example
      #   invoices = Bling::API::Invoice.new.list
      #
      # @return [Array] Call invoices index and return an array with records
      #
      def list
        get_request(t_url(:invoices))
      end

      # Get a specific invoice based on invoice number and invoice sequence
      #
      # @example
      #   invoice = Bling::API::invoice.new.get
      #
      # @param [String] cpf or cnpj from the invoice in Bling
      #
      # @return [Array] Call invoice#show and return an array with one record
      #
      def get(invoice_id, invoice_sequence)
        get_request(t_url(:invoice, invoice_id, invoice_sequence))
      end

      # Insert a invoice in Bling
      #
      # @example
      #   invoice = Bling::API::Invoice.new.create(
      #     {
      #     invoice_type: 'E',
      #     ecommerce_order_number: '123',
      #     operation_type: 'Venda de Mercadorias',
      #     user: {
      #      name: 'Jonh Doe',
      #      tax_type: 1,
      #      document: '35165478662',
      #      ie_rg: '306153420',
      #      icms_participant: 1,
      #      tax_classification: 1,
      #      address: 'My great street',
      #      number: '33',
      #      additional_address: 'apt 12',
      #      zipcode: '03454020',
      #      city: 'sao paulo',
      #      uf: 'SP',
      #      phone: '(11) 2233-3322',
      #      country: 'Brazil',
      #      email: 'jonh@@doe.com'
      #    },
      #    shipment: {
      #      carrier: 'Correios',
      #      document: '60120930390001',
      #      ie_rg: '306153420',
      #      full_address: 'My street, 33, apt 2',
      #      zipcode: '03454020',
      #      city: 'sao paulo',
      #      uf: 'SP',
      #      vehicle_place: 'DMZ-0112',
      #      vehicle_state: 'SP',
      #      shipment_type: 'D',
      #      shipments_size: '',
      #      shipments_kind: '',
      #      number: '12342',
      #      raw_weight: 20,
      #      weight: 18,
      #      correios_service: 'Sedex',
      #      shipment_label: {}
      #    },
      #    items: [
      #      { code: '001', description: 'lorem', unit: 'pc', item_quantity: 3, price: 12.30, origin: '0', tax_category: '1000.00.10'  },
      #      { code: '002', description: 'lorem', unit: 'pc', item_quantity: 4, price: 32.30, origin: '0', tax_category: '1000.00.10' },
      #    ],
      #    installments: [
      #      { days: '10', date: '28/06/2016', amount: 140.00, additional_info: '' },
      #      { days: '15', date: '28/07/2016', amount: 140.00, additional_info: '' },
      #    ],
      #    rural_reference_invoice: {
      #      number: '001230',
      #      sequence: '0',
      #      month_year_issue_date: '1202'
      #    },
      #    shipment_amount: 10.0,
      #    discount_amount: 0.0,
      #    expenses_amount: 2.5,
      #    additional_info: '',
      #    }
      #  )
      #
      # @param [Hash] params  A hash with order options
      #
      # @return [Array] Call invoice#create and return an array with one record
      #
      def create(params)
        post_request(t_url(:invoice), parsed_xml(params))
      end

      # Send an invoice to government
      #
      # @example
      #   invoice = Bling::API::invoice.new.update(invoice_number, invoice_sequence)
      #
      # @param [String] number from the invoice in Bling
      # @param [String] sequence for invoice in Bling
      #
      # @return [Array] Call invoice#show and return an array with one record
      #
      def put(invoice_number, invoice_sequence)
        #xml = order_update_template % { status: status.to_i }
        #put_request(t_url(:order, order_id), xml)
      end

      private


      def parsed_xml(params)
        @params = params
        @params = translate(@params) unless Bling.config.default_language == :en

        validate_user_params
        validate_items_params
        validate_installments_params

        shipment = @params.delete :shipment
        user = @params.delete :user
        items = @params.delete :items
        installments = @params.delete :installments

        @params[:user] = parse_user(user)
        @params[:shipment] = parse_shipment(shipment)
        @params[:items] = parse_items(items)
        @params[:installments] = parse_installments(installments)

        build_missing_params
        invoice_template % @params
      end

      def validate_object(key, klass)
        raise ArgumentError unless @params.has_key?(key) & @params[key].is_a?(klass)
      end

      def validate_user_params
        validate_object(:user, Hash)
        required_user_params = [:name, :tax_type, :address, :number, :neighborhood, :zipcode, :state, :email]
        validate(@params[:user], *required_user_params)
      end

      def validate_items_params
        validate_object(:items, Array)
        @params[:items].each do |item|
          validate(item, :description, :unit, :item_quantity, :price, :type, :origin)
        end
      end

      def validate_installments_params
        @params[:installments].each do |installment|
          validate(installment, :amount)
        end if @params[:installments]
      end

      def parse_user(user)
        invoice_user_template % build_user_missing_nodes(user)
      end

      def parse_shipment(shipment)
        invoice_shipment_template % build_shipment_missing_nodes(shipment)
      end

      def parse_items(items)
        build_item_missing_nodes(items)
          .each_with_object('') { |item, string| string.concat(invoice_item_template % item)  }
      end

      def parse_installments(installments)
        build_installment_missing_nodes(installments)
          .each_with_object('') { |installment, string| string.concat(invoice_installment_template % installment)  }
      end

      def build_missing_params
        xml_nodes.each { |node| @params[node] = nil unless @params.has_key?(node) }
      end

      def build_user_missing_nodes(user)
        # user is no array so we mock it
        build_missing_nodes(:user_xml_nodes, [user]).first
      end

      def build_shipment_missing_nodes(shipment)
        # shipment is no array so we mock it
        build_missing_nodes(:shipment_xml_nodes, [shipment]).first
      end

      def build_installment_missing_nodes(installments)
        build_missing_nodes(:installments_xml_nodes, installments)
      end

      def build_item_missing_nodes(items)
        build_missing_nodes(:item_xml_nodes, items)
      end

      def build_missing_nodes(node_array, records)
        records.each do |record|
          send(node_array).each { |node| record[node] = nil unless record.has_key?(node) }
        end
        records
      end

      def installments_xml_nodes
        [:day, :date, :amount, :additional_info]
      end

      def shipment_xml_nodes
        [
          :carrier,
          :document,
          :ie_rg,
          :full_address,
          :city,
          :state,
          :vehicle_plate,
          :vehicle_state,
          :shipment_type,
          :shipment_size,
          :shipment_kind,
          :number,
          :raw_weight,
          :weight,
          :correios_service,
          :shipment_label_name,
          :shipment_label_number,
          :shipment_label_additional_address,
          :shipment_label_city,
          :shipment_label_state,
          :shipment_label_zipcode,
          :shipment_label_neighborhood
        ]
      end

      def user_xml_nodes
        [
          :document,
          :ie_rg,
          :tax_classification,
          :address,
          :number,
          :additional_address,
          :neighborhood,
          :zipcode,
          :city,
          :state,
          :phone,
          :country,
          :email,
        ]
      end

      def item_xml_nodes
        [ :code,
          :description,
          :unit,
          :item_quantity,
          :price,
          :origin,
          :type,
          :weight,
          :raw_weight,
          :tax_category ]
      end

      def xml_nodes
        [
          :type,
          :ecommerce_order_number,
          :operation_type,
          :name,
          :tax_type,
          :rural_reference_invoice_number,
          :rural_reference_invoice_sequence,
          :rural_reference_invoice_date,
          :shipment_amount,
          :ensurance_amount,
          :expenses_amount,
          :discount_amount,
          :additional_info,
        ]
      end

    end
  end
end

