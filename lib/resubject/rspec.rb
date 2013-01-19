require 'resubject'

module Resubject
  # RSpec configuration and helpers
  #
  # This helper automatically creates `subject` and `template`
  # variables for RSpec when testing your presenter.
  #
  # To get this working, create a spec file in `spec/presenters`
  # and require `resubject/rspec`. You only need to define the
  # object under test by creating a `let(:object)`, like so:
  #
  # @example Isolated spec for MyPresenter
  #
  #   # spec/presenters/my_presenter_spec.rb
  #   require 'resubject/rspec'
  #   require 'presenters/my_presenter'
  #
  #   describe MyPresenter do
  #     let(:object) { mock :presented }
  #
  #     it 'has full name' do
  #       object.stub(first: 'My', last: 'Name')
  #       expect(subject.name).to eq 'My Name'
  #     end
  #   end
  #
  module Rspec
    # Extend RSpec configuration for files placed in `spec/presenters`
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
  end
end

::RSpec.configure do |c|
  c.include Resubject::Rspec,
            type: :presenter,
            example_group: { file_path: %r(spec/presenters) }
end
