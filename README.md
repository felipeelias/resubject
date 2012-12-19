# Resubject

[![Build Status](https://travis-ci.org/felipeelias/resubject.png?branch=master)](https://travis-ci.org/felipeelias/resubject)
[![Gem Version](https://fury-badge.herokuapp.com/rb/resubject.png)](http://badge.fury.io/rb/resubject)

Uber simple presenters using Ruby's SimpleDelegator.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resubject', '~> 0.0.1'
```

And then execute:

    $ bundle

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

presentable = BoxPresenter.new(box, nil)
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

## Maintainers

- Felipe Elias Philipp - [coderwall.com/felipeelias](http://coderwall.com/felipeelias)
- Piotr Jakubowski - [coderwall.com/piotrj](http://coderwall.com/piotrj)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
