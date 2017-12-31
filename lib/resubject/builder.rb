module Resubject
  module Builder
    # Raised when a invalid presenter is received
    class InvalidPresenterArgument < StandardError
    end

    # Presents a object or a collection of objects
    #
    # @param [Object, Array<Object>] objects objects to be instantiated with related presenter
    # @param template then HTML template context
    # @param [Presenter] presenters one or multiple presenters
    #
    # @return [Presenter, Array<Presenter>] either the presenter or a collection of presenter
    #
    # @example
    #
    #   Builder.present box, template
    #   # => <BoxPresenter>
    #
    #   # Using a custom presenter
    #   Builder.present box, template, CustomPresenter
    #   # => <CustomPresenter>
    #
    #   # Using multiple presenters
    #   Builder.present box, template, OnePresenter, CustomPresenter
    #   # => <OnePresenter<CustomPresenter>>
    #
    #   # Using a collection
    #   Builder.present [box, box], template
    #   # => [<BoxPresenter>, <BoxPresenter>]
    #
    # @see .present_one
    # @see .present_all
    #
    def self.present(objects, template, *presenters)
      if objects.respond_to?(:each)
        Builder.present_all(objects, template, *presenters)
      else
        Builder.present_one(objects, template, *presenters)
      end
    end

    # Presents a single object (see .present)
    #
    # @param [Object] object object to be instantiated with related presenter
    # @param template then HTML template context
    # @param [Presenter] presenters one or multiple presenters
    #
    # @raise [InvalidPresenterArgument] if a presenter was not received in presenters param
    #
    # @return [Presenter] either instance of the presenter related to the object
    #
    # @example
    #
    #   Builder.present_one box, context                              # => <BoxPresenter>
    #   Builder.present_one box, context, CustomPresenter             # => <CustomPresenter>
    #   Builder.present_one box, context, OnePresenter, TwoPresenter  # => <TwoPresenter<OnePresenter>>
    #
    # @example Skips nil classes
    #
    #   Builder.present_one nil
    #   # => nil
    #
    # @see .present
    #
    def self.present_one(object, template, *presenters)
      return unless object

      presenters = [Naming.presenter_for(object)] unless presenters.any?

      unless presenters.all? { |p| p.is_a?(Class) && p.ancestors.include?(Resubject::Presenter) }
        raise InvalidPresenterArgument, "Expected a presenter in #{presenters.inspect}"
      end

      presenters.inject(object) do |presented, klass|
        klass.new(presented, template)
      end
    end

    # Presents a collection of objects (see .present)
    #
    # @param [Array<Object>] objects objects to be instantiated with related presenter
    # @param template then HTML template context
    # @param [Presenter] presenters one or multiple presenters
    #
    # @return [Array<Presenter>] collection of instances of the related presenter
    #
    # @example
    #
    #   Builder.present [box, box], template
    #   # => [<BoxPresenter>, <BoxPresenter>]
    #
    # @see .present
    # @see .present_one
    #
    def self.present_all(objects, template, *presenters)
      objects.map do |o|
        Builder.present_one(o, template, *presenters)
      end
    end
  end
end
