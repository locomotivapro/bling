require 'json'

module Bling
  module API
    class Parser

      def initialize(text, klass_name)
        @text, @klass_name = text, klass_name
      end

      def result
        raw_response = JSON.parse(@text)
        Translator.translate_hash(raw_response, to: :en)
      end

      def records
        raw_records = result[:return][plural_klass_name]
        return [] if raw_records.nil?
        raw_records.each_with_object([]) { |record, result| result << Record.new(record[@klass_name]) }
      end

      private

      def plural_klass_name
        @klass_name.to_s.pluralize.to_sym
      end

    end
  end
end
