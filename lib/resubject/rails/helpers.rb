module Resubject
  module Helpers
    def self.included(base)
      base.send(:helper_method, :present)
      base.send(:private, :present_object)
    end

    def present(object, *presenter_classes)
      presenter = if object.respond_to?(:each)
        object.map { |o| present_object(o, presenter_classes) }
      else
        present_object(object, presenter_classes)
      end

      presenter.tap do |p|
        if block_given?
          yield p
        end
      end
    end

    def present_object(object, presenter_classes)
      presenter_classes = ["#{object.class}Presenter".constantize] if presenter_classes.empty?
      presenter_classes.inject(object) { |o, klass| klass.new(o, view_context) }
    end
  end
end
