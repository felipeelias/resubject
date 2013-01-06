# Resubject

[![Build Status](https://travis-ci.org/felipeelias/resubject.png?branch=master)](https://travis-ci.org/felipeelias/resubject)
[![Gem Version](https://fury-badge.herokuapp.com/rb/resubject.png)](http://badge.fury.io/rb/resubject)

Uber simple presenters using Ruby's SimpleDelegator.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resubject', '~> 0.0.2'
```

And then execute:

    $ bundle

## Documentation

Checkout the documentation in [rdoc.info/resubject](http://rdoc.info/github/felipeelias/resubject/master/frames)

## Usage

Resubject works on top of `SimpleDelegator` which simply delegates every method call to the delegated object. Example:

```ruby
class Box < Struct.new(:name, :items)
end

class BoxPresenter < Resubject::Presenter
  def contents
    items.join(', ')
  end
end
```

Then use the delegator:

```ruby
box = Box.new('Awkward Package', ['platypus', 'sloth', 'anteater'])

presentable = BoxPresenter.new(box)
presentable.contents
# => platypus, sloth, anteater
```

If you have a collection of objects and want to add a presenter to each one, use `Resubject.all`

```ruby
boxes = [box1, box2, box3]
BoxPresenter.all boxes
# => [<BoxPresenter>, <BoxPresenter>, <BoxPresenter>]
```

## Rails

If you're using rails, Resubject automatically includes helpers in your controllers and views

```ruby
class BoxesController < ActionController::Base
  def index
    @boxes = present Boxes.all
  end
end
```

The `#present` mehtod will automatically identify the presenter class by the object's class name. If you want to customize the class:

```ruby
def index
  @boxes = present Boxes.all, SpecialBoxPresenter
end
```

It also accepts multiple presenters:

```ruby
def index
  @boxes = present Boxes.all, BoxPresenter, ExtendedBoxPresenter
end
```

Or if you prefer, you can use the `#present` method directly into your views

```ruby
<%= present(@box).contents %>
```

## Helpers

You can define presentable attributes:

```ruby
class PostPresenter < Resubject::Presenter
  presents :title
  presents :comments # or => presents :comments, CommentPresenter
end
```

Then the attributes will return an instance of those presenters:

```ruby
post.title
# => <TitlePresenter>

post.comments
# => [<CommentPresenter>, <CommentPresenter>, <CommentPresenter>]
```

Or if you wish, you can use the `present` method inside your class

```ruby
class PostPresenter < Resubject::Presenter
  def comments
    present(to_model.comments, SomePresenter)
  end
end
```

### Helpers on Rails

`Resubject` can generate some rails helpers for your attributes:

```ruby
class ProductPresenter < Resubject::Presenter
  currency :price, precision: 2
end
```

Will generate:

```ruby
product.price
# => $10.00
```

Check out [the extensions file](https://github.com/felipeelias/resubject/blob/master/lib/resubject/rails/extensions.rb) for other attribute helpers.

## Maintainers

- Felipe Elias Philipp - [coderwall.com/felipeelias](http://coderwall.com/felipeelias)
- Piotr Jakubowski - [coderwall.com/piotrj](http://coderwall.com/piotrj)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
