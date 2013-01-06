module Resubject
  module Helpers
    def self.included(base)
      base.send(:helper_method, :present)
    end

    def present(object, *presenters)
      presenter = if object.respond_to?(:each)
        object.map do |o|
          Builder.present_one(o, view_context, *presenters)
        end
      else
        Builder.present_one(object, view_context, *presenters)
      end

      presenter.tap do |p|
        if block_given?
          yield p
        end
      end
    end
  end
end
