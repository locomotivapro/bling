require 'rails'

# @private
class Bling::Railtie < ::Rails::Railtie

  config.before_configuration do
    config.bling = Bling.config
  end
end
