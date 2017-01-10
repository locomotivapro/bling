require 'yaml'

module Bling
  module API
    class Translator

      I18N_FILE ||= YAML
        .load_file(File.join(File.dirname(__FILE__), 'locales/translations.yml'))
        .each_with_object({}){|(k,v), result| result[k.to_sym] = v.to_sym}

      class << self
        def translate_url(key, id: nil)
          url = pt[key.to_sym].to_s
          url +="/#{id}" if id
          url
        end

        def translate_hash(hash, to: :en)
          conversion_hash = send(to)

          hash.inject({}) do |result, (key, value)|
            new_key = conversion_hash[underscore_symbol(key)]
            new_key = underscore_symbol(key) if new_key.nil?

            new_value = case value
                        when Hash then translate_hash(value, to: to)
                        when Array then value.map! { |v| translate_hash(v, to: to) }
                        else value
                        end

            result[new_key] = new_value
            result
          end
        end

        private

        def underscore_symbol(key)
          key.to_s.
            gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase.
            to_sym
        end

        def en
          I18N_FILE
        end

        def pt
          @pt ||= I18N_FILE
            .dup
            .each_with_object({}) { |(key, value), result|  result[value] = key }
        end
      end

    end
  end
end
