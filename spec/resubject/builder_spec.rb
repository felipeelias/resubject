# frozen_string_literal: true

require 'spec_helper'

describe Resubject::Builder do
  let(:template) { double :template }

  before do
    stub_const 'Box', Class.new
    stub_const 'BoxPresenter', Class.new(Resubject::Presenter)
    stub_const 'OtherBoxPresenter', Class.new(Resubject::Presenter)
  end

  describe '.present_one' do
    it 'does not attempt to present nil' do
      presented = Resubject::Builder.present_one nil, template
      expect(presented).to be_nil
    end

    it 'presents the object with related class' do
      presented = Resubject::Builder.present_one Box.new, template
      expect(presented).to be_a BoxPresenter
    end

    it 'presents the object with custom class' do
      presented = Resubject::Builder.present_one Box.new, template, OtherBoxPresenter
      expect(presented).to be_a OtherBoxPresenter
    end

    it 'presents the object with multiple classes' do
      expect(OtherBoxPresenter).to receive(:new).twice
      presenters = [OtherBoxPresenter, OtherBoxPresenter]
      Resubject::Builder.present_one Box.new, template, *presenters
    end

    it 'raises an error if custom presenter is not a presenter' do
      expect do
        Resubject::Builder.present_one Box.new, template, nil, Class.new
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

    context 'with Struct objects' do
      before do
        stub_const 'MyStruct', Struct.new(:title, :description)
        stub_const 'MyStructPresenter', Class.new(Resubject::Presenter)
      end

      it 'presents a Struct as a single object, not a collection' do
        struct = MyStruct.new('hello', 'world')
        presented = Resubject::Builder.present struct, template
        expect(presented).to be_a MyStructPresenter
      end

      it 'presents an array of Structs as a collection' do
        structs = [MyStruct.new('a', 'b'), MyStruct.new('c', 'd')]
        presented = Resubject::Builder.present structs, template
        expect(presented).to be_an Array
        expect(presented.map(&:class)).to eq [MyStructPresenter, MyStructPresenter]
      end

      it 'presents a Struct with a custom presenter' do
        struct = MyStruct.new('hello', 'world')
        presented = Resubject::Builder.present struct, template, BoxPresenter
        expect(presented).to be_a BoxPresenter
      end
    end

    context 'with other Enumerable objects' do
      before do
        klass = Class.new do
          include Enumerable

          def each; end
        end
        stub_const 'EnumerableObj', klass
        stub_const 'EnumerableObjPresenter', Class.new(Resubject::Presenter)
      end

      it 'presents an Enumerable object as a single object' do
        obj = EnumerableObj.new
        presented = Resubject::Builder.present obj, template
        expect(presented).to be_a EnumerableObjPresenter
      end
    end

    context 'with Hash objects' do
      before do
        stub_const 'HashPresenter', Class.new(Resubject::Presenter)
      end

      it 'presents a Hash as a single object' do
        hash = { a: 1, b: 2 }
        presented = Resubject::Builder.present hash, template, HashPresenter
        expect(presented).to be_a HashPresenter
      end
    end
  end
end
