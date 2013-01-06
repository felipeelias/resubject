module Resubject
  module Builder
    # Presents a object or a collection of objects
    #
    # Examples:
    #
    #    Builder.present box, template
    #    => <BoxPresenter>
    #
    #    # Using a custom presenter
    #    Builder.present box, template, CustomPresenter
    #    => <CustomPresenter>
    #
    #    # Using multiple presenters
    #    Builder.present box, template, OnePresenter, CustomPresenter
    #    => <OnePresenter<CustomPresenter>>
    #
    #    # Using a collection
    #    Builder.present [box, box], template
    #    => [<BoxPresenter>, <BoxPresenter>]
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
    # Example:
    #
    #    Builder.present box, template
    #    => <BoxPresenter>
    #
    def self.present_one(object, template, *presenters)
      presenters = [Naming.presenter_for(object)] unless presenters.any?
      presenters.inject(object) do |presented, klass|
        klass.new(presented, template)
      end
    end

    # Presents a collection of objects (see .present)
    #
    # Example:
    #
    #    Builder.present [box, box], template
    #    => [<BoxPresenter>, <BoxPresenter>]
    #
    def self.present_all(objects, template, *presenters)
      objects.map do |o|
        Builder.present_one(o, template, *presenters)
      end
    end
  end
end
