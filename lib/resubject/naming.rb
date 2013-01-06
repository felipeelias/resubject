require 'active_support/core_ext/string/inflections'

module Resubject
  module Naming
    # Discover the presenter class given the class name or string/symbol passed
    #
    # @example
    #
    #   Naming.presenter_for :post     # => PostPresenter
    #   Naming.presenter_for "post"    # => PostPresenter
    #   Naming.presenter_for Post.new  # => PostPresenter
    #
    # @param [Object, String, Symbol] presentable the reference object
    # @return [Presenter] the related presenter class based on the object
    def self.presenter_for(presentable)
      klass = case presentable
        when Symbol
          presentable.to_s
        when String
          presentable
        else
          presentable.class.to_s
        end

      presenter = "#{klass.camelize}Presenter"

      Object.const_get presenter
    end
  end
end
