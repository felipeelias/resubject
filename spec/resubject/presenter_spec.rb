require 'spec_helper'

describe Resubject::Presenter do
  let(:object)   { mock :object }
  let(:template) { mock :template }

  subject { Resubject::Presenter.new(object, template) }

  it 'delegate methods to object' do
    object.should_receive(:pretty)
    subject.pretty
  end
end
