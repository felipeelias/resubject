require 'spec_helper'

describe Resubject::Builder do
  let(:template) { stub }

  before do
    stub_const 'Box', Class.new
    stub_const 'BoxPresenter', Class.new(Resubject::Presenter)
    stub_const 'OtherBoxPresenter', Class.new(Resubject::Presenter)
  end

  describe '.present_one' do
    it 'presents the object with related class' do
      presented = Resubject::Builder.present_one Box.new, template
      expect(presented).to be_a BoxPresenter
    end

    it 'presents the object with custom class' do
      presented = Resubject::Builder.present_one Box.new, template, OtherBoxPresenter
      expect(presented).to be_a OtherBoxPresenter
    end

    it 'presents the object with multiple classes' do
      OtherBoxPresenter.should_receive(:new).twice
      presenters = [OtherBoxPresenter, OtherBoxPresenter]
      presented  = Resubject::Builder.present_one Box.new, template, *presenters
    end
  end
end
