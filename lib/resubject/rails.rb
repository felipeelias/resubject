require 'resubject/rails/helpers'

module Resubject
  class Engine < ::Rails::Engine
    initializer "resubject.helpers" do
      ActiveSupport.on_load(:action_controller) do
        include Resubject::Helpers
      end
    end
  end
end
