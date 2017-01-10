module Bling
  module API
    class Response

      # @return [Net::HTTPResponse] The response object returned by Net::HTTP.
      attr_reader :http_response

      # @param [Net::HTTPResponse] http_response The response object returned by Net::HTTP.
      def initialize(http_response, klass_name)
        @http_response = http_response
        @klass_name = klass_name
      end

      # @return [String] The raw body of the response object.
      def body
        @http_response.body
      end

      # @return [Boolean] Whether or not the request was successful.
      def success?
        !http_failure? && without_errors
      end

      # @return [Boolean] Whether or not the HTTP request was a success.
      def http_failure?
        !@http_response.is_a?(Net::HTTPSuccess)
      end

      # @return [Array] with parsed response body.
      def records
        parsed_response.records if success?
      end

      private

      def without_errors
        parsed_response.result[:return] && parsed_response.result[:return][:errors].nil?
      end

      def parsed_response
        @parsed_response ||= Parser.new(body, @klass_name)
      end

    end
  end
end
