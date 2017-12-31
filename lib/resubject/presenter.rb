require 'delegate'

module Resubject
  class Presenter < SimpleDelegator
    extend Resubject::Extensions::TemplateMethods

    # the HTML helpers context
    attr_reader :context
    alias template context

    # Create a new presenter
    #
    # @param model any object that can be presented
    # @param context a context of HTML helpers
    #
    # @example
    #
    #   PostPresenter.new(post)
    #   PostPresenter.new(post, view_context)
    #
    def initialize(model, context = nil)
      @context = context
      super(model)
    end

    alias to_model __getobj__

    # Builds a collection of presenters given an array of objects
    #
    # @param [Array<Object>] collection
    # @param context the HTML helpers context
    # @return [Array<Presenter>] instances of a presenter for each item in the collection
    #
    # @example
    #
    #   boxes = [box1, box2, box3]
    #   BoxPresenter.all boxes
    #   # => [<BoxPresenter>, <BoxPresenter>, <BoxPresenter>]
    #
    #   PostPresenter.all Post.all
    #   # => [<PostPresenter>, ...]
    #
    def self.all(collection, context = nil)
      collection.map { |c| new(c, context) }
    end

    # Creates a presenter from object or collection of objects
    #
    # @example
    #
    #   present box                          # => <BoxPresenter>
    #   present [box, box]                   # => [<BoxPresenter>, <BoxPresenter>]
    #   present [box, box], CustomPresenter  # => <CustomPresenter>
    #
    # @param [Object, Array<Object>] objects objects to be instantiated with related presenter
    # @param [Presenter] presenters one or multiple presenters
    # @return [Presenter, Array<Presenter>] either the presenter or a collection of presenter
    #
    # @see Builder.present
    def present(objects, *presenters)
      Builder.present objects, context, *presenters
    end

    # Generates a instance method with the attribute presented
    #
    # @example
    #
    #   class BoxPresenter < Resubject::Presenter
    #     presents :name
    #     # or presents :name, CustomPresenter
    #   end
    #
    #   BoxPresenter.new(box).name   # => <NamePresenter>
    #
    # @example When the parent method is nil, it returns nil
    #
    #   box = BoxPresenter.new Box.new(name: nil)
    #   box.name
    #   # => nil
    #
    def self.presents(attribute, *presenters)
      define_method attribute do
        present to_model.send(attribute), *presenters
      end
    end

    private

    def translate(*args, &block)
      context.t(*args, &block)
    end

    alias t translate

    def localize(*args, &block)
      context.l(*args, &block)
    end

    alias l localize

    def helpers
      context
    end

    alias h helpers
  end
end
