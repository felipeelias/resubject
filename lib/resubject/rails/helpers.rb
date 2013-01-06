module Resubject
  module Helpers
    def self.included(base) #:nodoc:
      base.send(:helper_method, :present)
    end

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
