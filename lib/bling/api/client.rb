require 'net/http'

module Bling
  module API
    class Client

      # @param [String, Hash, Symbol] The constructor to build an HTTP request
      # and a response_class used to parse the response
      def initialize(url, params={}, response_class)
        @uri = build_uri(url)
        @params = params
        @response_class = response_class
      end

      # @return [Response] The accessor to a get request.
      def get
        uri.query = URI.encode_www_form(get_params(params))
        request = Net::HTTP.get_response(uri)
        Response.new(request, response_class)
      end

      # @return [Response] The accessor to a post request.
      def post
        Response.new(post_request, response_class)
      end

      # @return [Response] The accessor to a post request.
      def delete
        Response.new(delete_request, response_class)
      end

      private

      attr_reader :uri, :params, :response_class

      def delete_request
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')
        request = Net::HTTP::Delete.new(uri.path)
        request.set_form_data({ apikey: api_key })
        http.request(request)
      end

      def post_request
        post_params = {
          apikey: api_key,
          xml: params
        }
        Net::HTTP.post_form(uri, post_params)
      end

      def get_params(params)
        { apikey: api_key }.merge!(params)
      end

      def api_key
        Bling.config.api_key
      end

      def build_uri(url)
        format_type = Bling.config.response_format.to_s
        URI(Bling.config.api_url + url + '/' + format_type)
      end

    end
  end
end
