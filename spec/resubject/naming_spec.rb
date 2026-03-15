# frozen_string_literal: true

require 'spec_helper'

describe Resubject::Naming do
  before do
    stub_const 'Box', Class.new
    stub_const 'BoxPresenter', Class.new
  end

  it 'gets the presenter class from an object' do
    presenter = Resubject::Naming.presenter_for Box.new

    expect(presenter).to eq BoxPresenter
  end

  it 'gets the presenter class from a symbol' do
    presenter = Resubject::Naming.presenter_for :box

    expect(presenter).to eq BoxPresenter
  end

  it 'gets the presenter class from a string' do
    presenter = Resubject::Naming.presenter_for 'box'

    expect(presenter).to eq BoxPresenter
  end

  it 'gets namespaced constants' do
    stub_const 'Namespaced', Class.new
    stub_const 'Namespaced::BoxPresenter', Class.new

    presenter = Resubject::Naming.presenter_for 'Namespaced::Box'

    expect(presenter).to eq Namespaced::BoxPresenter
  end

  context 'when both top-level and namespaced presenters exist' do
    before do
      stub_const 'BoxPresenter', Class.new
      stub_const 'Fancy', Module.new
      stub_const 'Fancy::Box', Class.new
      stub_const 'Fancy::BoxPresenter', Class.new
    end

    it 'resolves to the namespaced presenter, not the top-level one' do
      presenter = Resubject::Naming.presenter_for Fancy::Box.new

      expect(presenter).to eq Fancy::BoxPresenter
    end

    it 'resolves to the namespaced presenter from a string' do
      presenter = Resubject::Naming.presenter_for 'Fancy::Box'

      expect(presenter).to eq Fancy::BoxPresenter
    end
  end

  context 'when only a top-level presenter exists but the object is namespaced' do
    before do
      stub_const 'ItemPresenter', Class.new
      stub_const 'Vendor', Module.new
      stub_const 'Vendor::Item', Class.new
      # Vendor::ItemPresenter is NOT defined
    end

    it 'raises NameError instead of falling back to the top-level presenter' do
      expect do
        Resubject::Naming.presenter_for Vendor::Item.new
      end.to raise_error(NameError)
    end
  end

  context 'with deeply nested namespaces' do
    before do
      stub_const 'A', Module.new
      stub_const 'A::B', Module.new
      stub_const 'A::B::Item', Class.new
      stub_const 'A::B::ItemPresenter', Class.new
    end

    it 'resolves deeply nested presenter' do
      presenter = Resubject::Naming.presenter_for A::B::Item.new

      expect(presenter).to eq A::B::ItemPresenter
    end
  end

  context 'when namespace exists but presenter does not' do
    before do
      stub_const 'Missing', Module.new
      stub_const 'Missing::Widget', Class.new
    end

    it 'raises NameError' do
      expect do
        Resubject::Naming.presenter_for Missing::Widget.new
      end.to raise_error(NameError)
    end
  end
end
