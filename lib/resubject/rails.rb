require 'resubject/rails/engine'

module Resubject
  class Presenter
    private

    def routes
      ::Rails.application.routes.url_helpers
    end

    alias r routes
  end
end
