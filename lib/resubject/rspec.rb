require 'resubject'

module Resubject
  module RspecHelpers
    def self.included(base)
      base.instance_eval do
        let(:template) do
          if defined? ActionView
            ActionView::Base.new
          else
            mock :template
          end
        end

        subject do
          described_class.new(object, template)
        end
      end
    end

    RSpec.configure do |config|
      config.include self,
                     :type => :presenter,
                     :example_group => { :file_path => %r(spec/presenters) }
    end
  end
end
