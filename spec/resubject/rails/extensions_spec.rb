require 'spec_helper'
require 'rails/all'
require 'resubject/rails'

describe Resubject::Presenter, 'extensions' do
  let(:model) { mock :model }

  let(:presenter) do
    Class.new(Resubject::Presenter) do
      currency :price
      time_ago :posted_at
    end
  end

  subject do
    presenter.new(model, ActionView::Base.new)
  end

  describe '.currency' do
    it 'returns currency format' do
      model.should_receive(:price).and_return(10.0)
      expect(subject.price).to eq "$10.00"
    end
  end

  describe '.time_ago' do
    it 'returns time ago in words' do
      model.stub(:posted_at).and_return(Time.now - 60 * 60)
      expect(subject.posted_at).to eq "about 1 hour"
    end

    it 'returns nothing if value is nil' do
      model.stub(:posted_at).and_return(nil)
      expect(subject.posted_at).to eq nil
    end
  end
end
