require 'spec_helper'

describe Resubject::Presenter do
  let(:object) { double :object }

  subject { Resubject::Presenter.new(object) }

  it 'delegate methods to object' do
    expect(object).to receive(:pretty)
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

  describe '.presents' do
    let :presenter do
      Class.new(Resubject::Presenter) do
        presents :item
        presents :other_item, ItemPresenter
      end
    end

    before do
      stub_const 'Item', Class.new
      stub_const 'ItemPresenter', Class.new(Resubject::Presenter)
    end

    it 'generates a method preseting the attribute' do
      box = double :box, item: Item.new

      expect(presenter.new(box).item).to be_a ItemPresenter
    end

    it 'does not attempt to find a class from nil' do
      box = double :box, item: nil

      expect(presenter.new(box).item).to be_nil
    end

    it 'presents the attributes with custom presenter' do
      box = double :box, other_item: double(:other)

      expect(presenter.new(box).other_item).to be_a ItemPresenter
    end
  end
end
