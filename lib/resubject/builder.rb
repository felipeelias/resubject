module Resubject
  module Builder
    def self.present_one(object, template, *presenters)
      presenters = [Naming.presenter_for(object)] unless presenters.any?
      presenters.inject(object) do |presented, klass|
        klass.new(presented, template)
      end
    end
  end
end
