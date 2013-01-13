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

      # Generates an attribute using `time_ago_in_words` helper from rails
      #
      # @example
      #
      #   class ProductPresenter < Resubject::Presenter
      #     time_ago :posted_at
      #   end
      #
      #   # Will redefine the `posted_at` attribute using `time_ago_in_words`
      #
      #   product.posted_at
      #   # => 'about 1 hour'
      #
      # @param [Symbol] attribute the name of the attribute to be generated
      # @see http://apidock.com/rails/ActionView/Helpers/DateHelper/time_ago_in_words
      def time_ago(attribute, include_seconds = false)
        define_method attribute do
          return if to_model.send(attribute).nil?
          template.time_ago_in_words to_model.send(attribute), include_seconds
        end
      end

      # Generates an attribute using `number_to_percentage` helper from rails
      #
      # @example
      #
      #   class ProductPresenter < Resubject::Presenter
      #     percentage :rating
      #   end
      #
      #   # Will create a `rating` attribute using `number_to_percentage`
      #
      #   product.rating
      #   # => '95.000%'
      #
      # @example Also, any number_to_percentage options are accepted
      #
      #   currency :rating, precision: 0   # => '95%'
      #   currency :rating, locale: :fr    # => '1 000,000%'
      #
      # @param [Symbol] attribute the name of the presented attribute to be generated
      # @param [Hash] options the options for `number_to_percentage` method
      # @see http://apidock.com/rails/ActionView/Helpers/NumberHelper/number_to_percentage
      def percentage(attribute, options = {})
        define_method attribute do
          template.number_to_percentage to_model.send(attribute), options
        end
      end
    end
  end
end
