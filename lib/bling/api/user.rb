module Bling
  module API
    # This class is used to make requests to all available
    # actions related to users in Bling api. Is strongly recommended
    # to use the Bling::API module wrapper
    #
    class User < Request
      # Get a list of available users
      #
      # @example
      #   users = Bling::API::User.new.list
      #
      # @return [Array] Call users index and return an array with records
      #
      def list
        get_request(t_url(:users))
      end

      # Get a specific object based on user_id
      #
      # @example
      #   user = Bling::API::user.new.get
      #
      # @param [String] cpf or cnpj from the user in Bling
      #
      # @return [Array] Call user#show and return an array with one record
      #
      def get(user_id)
        get_request(t_url(:user, user_id))
      end

      # Insert a user in Bling
      #
      # @example
      #   user = Bling::API::User.new.create(
      #     {
      #     name: 'Jonh Doe',
      #     company_name: '',
      #     tax_type: 1,
      #     document: '35165478662',
      #     ir_rg: '306153420',
      #     address: 'My great street',
      #     number: '33',
      #     additional_address: 'apt 12',
      #     zipcode: '03454020',
      #     city: 'Sao Paulo',
      #     uf: 'SP',
      #     phone: '(11) 2233-3322',
      #     email: jonh@@doe.com'
      #     }
      #   )
      #
      # @param [Hash] params  A hash with user options
      #
      # @return [Array] Call user#create and return an array with one record
      #
      def create(params)
        post_request(t_url(:user), parsed_xml(params))
      end

      private

      def parsed_xml(params)
        params = translate(params) unless Bling.config.default_language == :en
        validate(params, :name, :user_type, :tax_type, :document)
        user_template % params
      end

    end
  end
end

