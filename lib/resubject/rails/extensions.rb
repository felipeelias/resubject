module Resubject
  module Rails
    # All Rails extensions
    module Extensions
      # Generates an attribute using `number_to_currency` helper from rails
      #
      # @example
      #
      #   class ProductPresenter < Resubject::Presenter
      #     currency :price
      #   end
      #
      #   # Will create a `price` attribute using `number_to_currency`
      #
      #   product.price
      #   # => '$10.00'
      #
      # @example Also, any number_to_currency options are accepted
      #
      #   currency :price, precision: 3   # => '$123.456'
      #   currency :price, locale: :fr    # => '123,51 €'
      #
      # @param [Symbol] attribute the name of the presented attribute to be generated
      # @param [Hash] options the options for `number_to_currency` method
      # @see http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html#method-i-number_to_currency
      def currency(attribute, options = {})
        define_method attribute do
          template.number_to_currency to_model.send(attribute), options
        end
      end
    end
  end
end
