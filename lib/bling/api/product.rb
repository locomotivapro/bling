module Bling
  module API
    # This class is used to make requests to all available
    # actions related to products in Bling api. Is strongly recommended
    # to use the Bling::API module wrapper
    #
    class Product < Request

      # Get a list of available products
      #
      # @example
      #   products = Bling::API::Product.new.list
      #
      # @return [[Record]] Call products index and return an array with records
      #
      def list
        get_request(t_url(:products))
      end

      # Get a specific object based on product_id
      #
      # @example
      #   product = Bling::API::Product.new.get
      #
      # @param [Integer,String] product_id The product id in Bling
      #
      # @return [[Record]] Call product show and return an arrayn with one record
      #
      def get(product_id)
        get_request(t_url(:product, product_id))
      end

      # Insert a product in Bling
      #
      # @example
      #   product = Bling::API::Product.new.create(
      #     {
      #     code: '92314',
      #     description: 'Awesome product',
      #     additional_description: 'In lovely colors',
      #     unit: 'Pc',
      #     price: 20.50,
      #     cost_price: 14.30,
      #     raw_weight: 2,
      #     weight: 1.8,
      #     tax_category: '1000.01.01',
      #     origin: 0,
      #     quantity: 10,
      #     gtin: 832222,
      #     gtin_package: 13414,
      #     width: 25,
      #     height: 15,
      #     depth: 10,
      #     min_quantity: 1,
      #     max_quantity: 200
      #     }
      #   )
      #
      # @param [Hash] params  A hash with product options
      #
      # @return [[Record]] Call product show and return an array with one record
      #
      def create(params)
        @params = params
        post_request(t_url(:product), parsed_xml)
      end

      # Update a product in Bling
      #
      # @example
      #   product = Bling::API::Product.new.create(
      #     {
      #     code: '92314',
      #     description: 'Awesome product',
      #     additional_description: 'In lovely colors',
      #     unit: 'Pc',
      #     price: 20.50,
      #     cost_price: 14.30,
      #     raw_weight: 2,
      #     weight: 1.8,
      #     tax_category: '1000.01.01',
      #     origin: 0,
      #     quantity: 10,
      #     gtin: 832222,
      #     gtin_package: 13414,
      #     width: 25,
      #     height: 15,
      #     depth: 10,
      #     min_quantity: 1,
      #     max_quantity: 200
      #     }
      #   )
      #
      # @param [Integer, String] product_id  The product id in Bling
      # @param [Hash] params  A hash with product options
      #
      # @return [[Record]] Call product show and return an array with one record
      #
      def update(product_id, params)
        @params = params
        post_request(t_url(:product, product_id), parsed_xml)
      end

      # Delete a product in Bling
      #
      # @example
      #   Bling::API::Product.new.delete(1)
      #
      # @param [Integer,String] product_id The product id in Bling
      #
      # @return [[Record]] Call product show and return an array with one record
      #
      def delete(product_id)
        delete_request(t_url(:product, product_id))
      end

      private

      def parsed_xml
        @params = translate(@params) unless Bling.config.default_language == :en
        validate(@params, :description, :price)
        build_missing_keys
        product_template % @params
      end

      def build_missing_keys
        xml_nodes.each do |node|
          @params[node] = nil unless @params.has_key?(node)
        end
      end

      def xml_nodes
        %i(code description
           additional_description unit price
           cost_price raw_weight weight
           tax_category origin quantity gtin
           gtin_package width height depth
           min_quantity max_quantity cest)
      end

    end
  end
end
