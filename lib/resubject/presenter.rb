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

    # Creates a presenter from object or collection of objects
    # See Builder.present for more details
    # Example:
    #
    #    present box
    #    => <BoxPresenter>
    #
    def present(objects, *presenters)
      Builder.present objects, context, *presenters
    end

    # Generates a instance method with the attribute presented
    #
    # Example:
    #
    #    class BoxPresenter < Resubject::Presenter
    #      presents :name
    #      # or
    #      # presents :name, CustomPresenter
    #    end
    #
    #    BoxPresenter.new(box).name
    #    => <NamePresenter>
    #
    def self.presents(attribute, *presenters)
      define_method attribute do
        present to_model.send(attribute), *presenters
      end
    end
  end
end
