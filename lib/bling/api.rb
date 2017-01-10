module Bling
  module API
    # This module encapsulates all API groups
    # and creates an instance for it. You can make a direct
    # call like Bling::API::Product.new.list but it`s best and
    # less verbose to use this module ex: Bling::API.product.list
    #
    # To see all methods available to each instance, please look
    # in each respectively class

    extend self

    def product
      Product.new
    end

    def user
      User.new
    end

    def order
      Order.new
    end

  end
end
