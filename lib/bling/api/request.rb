module Bling
  module API
    class Request

      private

      def get_request(url)
        Client.new(url, {}, klass_name).get
      end

      def post_request(url, params)
        Client.new(url, params, klass_name).post
      end

      def put_request(url, params)
        Client.new(url, params, klass_name).post
      end

      def delete_request(url)
        Client.new(url, {}, klass_name).delete
      end

      def klass_name
        self.class.to_s.split('::').last.downcase.to_sym
      end

      def t_url(url, id=nil)
        Translator.translate_url(url, id: id)
      end

      def translate(params)
        Translator.translate_hash(params)
      end

      def validate(params, *required_params)
        required_params.each do |param|
          if params[param].nil? || params[param] =~ /^\s*$/
            raise ArgumentError, "The required parameter `:#{param}' is missing."
          end
        end
      end

      def method_missing(method, *args, &block)
        if method.to_s =~/\A.+_template\z/
          IO.read(File.join(File.dirname(__FILE__), "templates", method.to_s))
        else
          super(method, args, &block)
        end
      end

    end
  end
end
