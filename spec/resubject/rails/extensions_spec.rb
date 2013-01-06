require 'rails/all'
require 'spec_helper'

describe Resubject::Rails::Extensions do
  let(:model) { mock :model }

  let(:presenter) do
    Class.new(Resubject::Presenter) do
      currency :price
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
end
