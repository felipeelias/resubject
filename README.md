# Resubject

[![Build Status](https://travis-ci.org/felipeelias/resubject.svg?branch=master)](https://travis-ci.org/felipeelias/resubject)
[![Gem Version](https://badge.fury.io/rb/resubject.svg)](https://badge.fury.io/rb/resubject)
[![Code Climate](https://codeclimate.com/github/felipeelias/resubject/badges/gpa.svg)](https://codeclimate.com/github/felipeelias/resubject)

Uber simple presenters using Ruby's SimpleDelegator.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resubject', '~> 0.3.0'
```

And then execute:

    $ bundle

## Ruby/Rails versions

This gem is compatible with Ruby 1.9 and 2.0 and Rails 3 and 4.

## Documentation

Checkout the documentation in [rdoc.info/resubject](http://rdoc.info/github/felipeelias/resubject/master/frames)

## Introduction

Resubject uses Ruby's [SimpleDelegator](http://apidock.com/ruby/SimpleDelegator) class to create its presenters.

SimpleDelegator is a concrete implementation of the Delegator class. Basically, it delegates any method calls to the object passed into the constructor:

```ruby
require 'delegate'

array = SimpleDelegator.new([1, 2, 3])

array.count # => 3
array.map   # => #<Enumerator: ...>
```

It doesn't override the class name, but you still can access the original object.

```ruby
array.class
# => SimpleDelegator
array.__getobj__.class
# => Array
```

This means you can create a class that inherits from SimpleDelegator and customize its behaviour:

```ruby
class ForeverZeroArray < SimpleDelegator
  def omg!
    "OMG!"
  end

  def count
    0
  end
end
```

You can define new methods or override existing ones:

```ruby
ForeverZeroArray.new([1,2,3]).count
# => 0
ForeverZeroArray.new([1,2,3]).omg!
# => OMG!
```

## Usage

Using the `Resubject::Presenter` class, you can create Presenters from it. Example:

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

The `#present` method will automatically identify the presenter class by the object's class name. If you want to customize the class:

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

#### Available helpers

```text
Presenter           Maps to                     Class/Module

currency            number_to_currency          ActionView::Helpers::NumberHelper
percentage          number_to_percentage        ActionView::Helpers::NumberHelper
time_ago            time_ago_in_words           ActionView::Helpers::DateHelper
date_format         to_s                        ActiveSupport::TimeWithZone
```

More helpers will be added. Feel free to contribute with yours! Also, Check out [the extensions file](https://github.com/felipeelias/resubject/blob/master/lib/resubject/extensions/template_methods.rb).

### Helpers without rails

If you'd like to use the generated helpers but you're not using Rails, you can either use `ActionView` or create your own template handler:

```ruby
require 'action_view'

post = PostPresenter.new(post, ActionView::Base.new)
# Or
post = PostPresenter.new(post, MyTemplateHandler.new)
```

If you want to use your own template handler and still use Resubject helpers, you may want to define the same `ActionView` helpers in your handler (or only the ones you will actually use).

## Testing

Resubject introduces a new context for RSpec that helps testing your presenters:

```ruby
# spec/presenters/my_presenter_spec.rb
# require 'action_view' # require this first if you want to test action view helpers
require 'resubject/rspec'
require 'presenters/my_presenter'

describe UserPresenter do
  let(:object) { double :user }

  it 'has full name' do
    object.stub(first: 'User', last: 'Name')
    expect(subject.name).to eq 'User Name'
  end
end
```

By placing the file into `spec/presenters`, Resubject automatically includes the `subject` and `template` variables into your spec, so you don't need to define them on every spec.

**NOTE:** Please note that the presenter is tested on isolation. It's not required but very recommended.

## Maintainers

- Felipe Elias Philipp - [coderwall.com/felipeelias](http://coderwall.com/felipeelias)
- Piotr Jakubowski - [coderwall.com/piotrj](http://coderwall.com/piotrj)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
