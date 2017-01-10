module Bling
  module API
    # This class is used to make requests to all available
    # actions related to orders in Bling api. Is strongly recommended
    # to use the Bling::API module wrapper
    #
    class Order < Request
      # Get a list of available orders
      #
      # @example
      #   orders = Bling::API::Order.new.list
      #
      # @return [Array] Call orders index and return an array with records
      #
      def list
        get_request(t_url(:orders))
      end

      # Get a specific object based on order_id
      #
      # @example
      #   order = Bling::API::order.new.get
      #
      # @param [String] cpf or cnpj from the order in Bling
      #
      # @return [Array] Call order#show and return an array with one record
      #
      def get(order_id)
        get_request(t_url(:order, order_id))
      end

      # Insert a order in Bling
      #
      # @example
      #   order = Bling::API::Order.new.create(
      #     {
      #     order_number: '123',
      #     ecommerce_order_number: 'R123',
      #     store: 'Foo',
      #     selling_category: '',
      #     user: {
      #      name: 'Jonh Doe',
      #      company_name: '',
      #      tax_type: 1,
      #      document: '35165478662',
      #      ir_rg: '306153420',
      #      tax_classification: 1,
      #      address: 'My great street',
      #      number: '33',
      #      additional_address: 'apt 12',
      #      zipcode: '03454020',
      #      city: 'Sao Paulo',
      #      uf: 'SP',
      #      phone: '(11) 2233-3322',
      #      cellphone: '(11) 2233-3322',
      #      email: jonh@@doe.com'
      #     },
      #     shipment: {
      #       carrier: 'Correios',
      #       shipment_type: 'R'
      #       shipment_label: {}
      #     },
      #     items: [
      #       { code: '001', description: 'lorem', unit: 'pc', item_quantity: 3, price: 12.30 },
      #       { code: '002', description: 'lorem', unit: 'pc', item_quantity: 4, price: 32.30 },
      #     ],
      #     installments: [
      #       { date: '28/06/2016', amount: 140.00, additional_info: '' },
      #       { date: '28/07/2016', amount: 140.00, additional_info: '' },
      #     ],
      #     shipment_amount: 10.0,
      #     discount_amount: 0.0,
      #     additional_info: '',
      #     private_additional_info: ''
      #     }
      #   )
      #
      # @param [Hash] params  A hash with order options
      #
      # @return [Array] Call order#create and return an array with one record
      #
      def create(params)
        post_request(t_url(:order), parsed_xml(params))
      end

      # Put an order status update based on order_id
      #
      # Available statuses
      #
      #  - 0 (Em Aberto)
      #  - 1 (Atendido)
      #  - 2 (Cancelado)
      #  - 3 (Em Andamento)
      #  - 4 (Venda Agenciada)
      #  - 10 (Em Digitação)
      #  - 11 (Verificado)
      #
      # @example
      #   order = Bling::API::order.new.update(order_id, status)
      #
      # @param [String] cpf or cnpj from the order in Bling
      # @param [Integer] status number for order in Bling
      #
      # @return [Array] Call order#show and return an array with one record
      #
      def put(order_id, status)
        raise ArgumentError unless [0, 1, 2, 3, 4, 10, 11].include?(status.to_i)
        xml = order_update_template % { status: status.to_i }
        put_request(t_url(:order, order_id), xml)
      end

      private


      def parsed_xml(params)
        @params = params
        @params = translate(@params) unless Bling.config.default_language == :en

        validate(@params, :name)

        validate_object(:items, Array)
        @params[:items].each do |item|
          validate(item, :description, :code, :item_quantity, :price)
        end

        @params[:installments].each do |installment|
          validate(installment, :amount)
        end if @params[:installments]

        items = @params.delete :items
        installments = @params.delete :installments

        @params[:items] = parse_items(items)
        @params[:installments] = parse_installments(installments)

        build_missing_params
        order_template % @params
      end

      def validate_object(key, klass)
        raise ArgumentError unless @params.has_key?(key) & @params[key].is_a?(klass)
      end

      def parse_items(items)
        build_item_missing_nodes(items)
          .each_with_object('') { |item, string| string.concat(order_item_template % item)  }
      end

      def parse_installments(installments)
        build_installment_missing_nodes(installments)
          .each_with_object('') { |installment, string| string.concat(order_installment_template % installment)  }
      end

      def build_missing_params
        xml_nodes.each { |node| @params[node] = nil unless @params.has_key?(node) }
      end

      def build_installment_missing_nodes(installments)
        installments.each do |installment|
          installments_xml_nodes.each { |node| installment[node] = nil unless installment.has_key?(node) }
        end
        installments
      end

      def build_item_missing_nodes(items)
        items.each do |item|
          item_xml_nodes.each { |node| item[node] = nil unless item.has_key?(node) }
        end
        items
      end

      def installments_xml_nodes
        [:date, :amount, :additional_info]
      end

      def item_xml_nodes
        [ :code, :description, :unit, :item_quantity, :price ]
      end

      def xml_nodes
        [
          :date,
          :order_number,
          :ecommerce_order_number,
          :store,
          :selling_category,
          :name,
          :tax_type,
          :address,
          :document,
          :ie_rg,
          :tax_classification,
          :number,
          :additional_address,
          :neighborhood,
          :zipcode,
          :city,
          :state,
          :phone,
          :cellphone,
          :email,
          :carrier,
          :shipment_type,
          :correios_service,
          :shipment_label_name,
          :shipment_label_address,
          :shipment_label_number,
          :shipment_label_additional_address,
          :shipment_label_city,
          :shipment_label_state,
          :shipment_label_zipcode,
          :shipment_label_neighborhood,
          :shipment_amount,
          :discount_amount,
          :additional_info,
          :private_additional_info
        ]
      end

    end
  end
end

