require 'active_support/core_ext/string/inflections'

module Resubject
  module Naming
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
