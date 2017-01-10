module Bling
  module API
    class Record

      # @return [Hash] The original hash attributes passed on initialize
      attr_reader :attrs

      # @params [Hash] A hash that will generate accessors for each key
      def initialize(hash)
        @attrs = hash
      end

      private

      def method_missing(method, *args, &block)
        if attrs.has_key?(method)
          attrs[method]
        else
          super(method, args, block)
        end
      end

    end
  end
end
