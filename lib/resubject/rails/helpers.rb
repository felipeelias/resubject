module Resubject
  # ActionController helpers
  #
  # In case you have Rails, these helpers will be automatically included
  #
  module Helpers
    # adds present as a helper method in the controller
    def self.included(base)
      base.send(:helper_method, :present)
    end

    # @see Builder.present
    def present(objects, *presenters)
      presenters = Builder.present(objects, view_context, *presenters)

      presenters.tap do |p|
        if block_given?
          yield p
        end
      end
    end
  end
end
