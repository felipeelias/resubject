require 'delegate'

module Resubject
  class Presenter < SimpleDelegator
    attr_reader  :context
    alias_method :template, :context

    def initialize(model, context = nil)
      @context = context
      super(model)
    end

    alias_method :to_model, :__getobj__

    # Builds a collection of presenters given an array of objects
    #
    # Example:
    #
    #   boxes = [box1, box2, box3]
    #   BoxPresenter.all boxes
    #   # => [<BoxPresenter>, <BoxPresenter>, <BoxPresenter>]
    #
    def self.all(collection, context = nil)
      collection.map { |c| new(c, context) }
    end

  private

    def self.inject_presenter_for(*options)
      options.each do |resource|
        presenter_name = "#{resource}_presenter"
        attr_writer presenter_name

        define_method presenter_name do
          instance_variable_get("@#{presenter_name}") || presenter_name.camelize.constantize
        end

        define_method "present_#{resource}" do |object|
          send(presenter_name).new(object, @context)
        end
      end
    end
  end
end
