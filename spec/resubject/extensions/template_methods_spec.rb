require 'spec_helper'
require 'action_view'

describe Resubject::Presenter, 'template methods' do
  let(:model) { mock :model }

  let(:presenter) do
    Class.new(Resubject::Presenter) do
      currency :price
      time_ago :posted_at
      percentage :rating, precision: 0
      date_format :created_at, :short
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

  describe '.percentage' do
    it 'returns formatted percentage' do
      model.stub(:rating).and_return(95.123)
      expect(subject.rating).to eq "95%"
    end
  end

  describe '.date_format' do
    it 'returns formatted date' do
      model.stub(:created_at).and_return(Time.at(1358082653).utc)
      expect(subject.created_at).to eq "13 Jan 13:10"
    end

    it 'returns nothing if value is nil' do
      model.stub(:created_at).and_return(nil)
      expect(subject.created_at).to eq nil
    end
  end
end
