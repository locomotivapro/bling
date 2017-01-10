module Bling
  class Config

    def initialize
      @api_url = 'https://bling.com.br/Api/v2/'
      @response_format = :json
    end

    # The api key supplied by Bling service.
    #
    # @return [String]
    attr_accessor :api_key

    # Set response format from Bling, can be :xml or :json (default).
    #
    # @param [:xml, :json, 'xml', 'json']
    def response_format=(response_format)
      @response_format = @response_format.to_sym
    end

    # The base API url
    #
    # @return [String]
    attr_reader :api_url

    # The response format from Bling, can be :xml or :json (default).
    #
    # @return [Symbol]
    def response_format
      @response_format || :json
    end

    # The default language if set to english lib will translate
    # to portuguese before actually make request. Default to :en
    #
    # @param [:pt, :en]
    def default_language=(language)
      raise ArgumentError unless [:en, :pt].include?(language.to_sym)
      @default_language = language.to_sym
    end

    # The default language of API params
    #
    # @return [Symbol]
    def default_language
      @default_language || :en
    end

  end
end
