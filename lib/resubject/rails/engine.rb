module Resubject
  class Engine < ::Rails::Engine #:nodoc:
    initializer 'resubject.helpers' do
      ActiveSupport.on_load(:action_controller) do
        require 'resubject/rails/helpers'
        include Resubject::Helpers
      end
    end
  end
end
