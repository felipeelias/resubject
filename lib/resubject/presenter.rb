require 'delegate'

module Resubject
  class Presenter < SimpleDelegator
    attr_reader  :context
    alias_method :template, :context

    def initialize(model, context = nil)
      @context = context
      super(model)
    end

    def to_model
      __getobj__
    end

    def self.all(collection, template)
      collection.map { |object| new(object, template) }
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
