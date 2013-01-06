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

    it 'raises an error if custom presenter is not a presenter' do
      expect do
        Resubject::Builder.present_one Box.new, template, *[nil, Class.new]
      end.to raise_error(Resubject::Builder::InvalidPresenterArgument)
    end
  end

  describe '.present_all' do
    it 'presents multiple objects' do
      box = Box.new
      presented = Resubject::Builder.present_all [box, box], template

      expect(presented.map(&:class)).to eq [BoxPresenter, BoxPresenter]
    end

    it 'presents multiple objects with custom presenters' do
      box = Box.new
      presented = Resubject::Builder.present_all [box, box], template, OtherBoxPresenter

      expect(presented.map(&:class)).to eq [OtherBoxPresenter, OtherBoxPresenter]
    end
  end

  describe '.present' do
    it 'presents single object' do
      presented = Resubject::Builder.present Box.new, template
      expect(presented).to be_a BoxPresenter
    end

    it 'presents multiple objects' do
      box = Box.new
      presented = Resubject::Builder.present [box, box], template

      expect(presented.map(&:class)).to eq [BoxPresenter, BoxPresenter]
    end
  end
end
