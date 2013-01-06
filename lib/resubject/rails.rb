require 'resubject/rails/engine'
require 'resubject/rails/extensions'

module Resubject
  class Presenter
    extend Resubject::Rails::Extensions

    private

    def translate(*args, &block)
      context.t(*args, &block)
    end

    alias_method :t, :translate

    def localize(*args, &block)
      context.l(*args, &block)
    end

    alias_method :l, :localize

    def routes
      ::Rails.application.routes.url_helpers
    end

    alias_method :r, :routes

    def helpers
      context
    end

    alias_method :h, :helpers
  end
end
