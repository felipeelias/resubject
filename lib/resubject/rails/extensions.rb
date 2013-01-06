module Resubject
  module Rails #:nodoc:
    module Extensions
      def currency(attribute, options = {})
        define_method attribute do
          template.number_to_currency to_model.send(attribute), options
        end
      end
    end
  end
end
