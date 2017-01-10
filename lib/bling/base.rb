require 'bling/config'

module Bling
  class Error < ::StandardError
  end

  # @return [Config] The config singleton.
  def self.config
    @config ||= Bling::Config.new
  end

  def self.config=(config)
    @config = config
  end
end
