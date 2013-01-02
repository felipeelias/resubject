Present a object with a symbol

    present user, context: :public
    # => present user, PublicUserPresenter

    present user, :public, :crazy
    # => present user, PublicPresenter, CrazyPresenter

    # best way to handle this?
    present user, :public, :user
    # => present user, PublicPresenter, UserPresenter

Helper class methods

    class UserPresenter < Resubject::Presenter
      # formats to default (to_s), only if present
      # object.created_at
      timestamp :created_at

      # formats to long (to_s(:long))
      timestamp :created_at, format: :long

      # multiple
      timestamps :created_at, :updated_at

      autolink!
      # create object.link

      # currency format
      currency :price

      # change options
      currency :price, format: 'whatever'
    end

Test helpers

    describe UserPresenter do
      it 'has currency' do
        user = stub price: 200.0
        presented(user).currency.should == '$200.00'
      end

      # or

      subject { UserPresenter.new(stub(price: 200.0)) }

      it 'has currency' do
        presented.currency.should == '$200'
      end
    end
