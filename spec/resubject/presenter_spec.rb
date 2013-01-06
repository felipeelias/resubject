require 'spec_helper'

describe Resubject::Presenter do
  let(:object)   { mock :object }

  subject { Resubject::Presenter.new(object) }

  it 'delegate methods to object' do
    object.should_receive(:pretty)
    subject.pretty
  end

  describe :to_model do
    it 'returns the delegated object' do
      expect(subject.to_model).to eq object
    end
  end

  describe '.all' do
    it 'creates various instances of the presenter' do
      presented = Resubject::Presenter.all([object, object])

      expect(presented.map(&:class)).to eq [Resubject::Presenter,
                                            Resubject::Presenter]
    end
  end

  describe :present do
    it 'creates a presenter' do
      stub_const 'Box', Class.new
      stub_const 'BoxPresenter', Class.new(Resubject::Presenter)

      presented = subject.present Box.new
      expect(presented).to be_a BoxPresenter
    end
  end
end
