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
end
