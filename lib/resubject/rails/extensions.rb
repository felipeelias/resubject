module Resubject
  module Rails #:nodoc:
    module Extensions
      # Generates an attribute using `number_to_currency` helper from rails
      #
      # Examples:
      #
      #    class ProductPresenter < Resubject::Presenter
      #      currency :price
      #    end
      #
      #    # Will create a `price` attribute using `number_to_currency`
      #
      #    product.price
      #    # => '$10.00'
      #
      # Options:
      #
      #    currency :price, precision: 3   # => '$123.456'
      #    currency :price, locale: :fr    # => '123,51 €'
      #
      # See ActionView::Helpers::NumberHelper#number_to_currency[http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html#method-i-number_to_currency] for other options
      def currency(attribute, options = {})
        define_method attribute do
          template.number_to_currency to_model.send(attribute), options
        end
      end
    end
  end
end
