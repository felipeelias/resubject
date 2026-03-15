# Resubject

[![CI](https://github.com/felipeelias/resubject/actions/workflows/ci.yml/badge.svg)](https://github.com/felipeelias/resubject/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/resubject.svg)](https://badge.fury.io/rb/resubject)

Simple presenters built on Ruby's [`SimpleDelegator`](https://ruby-doc.org/stdlib/libdoc/delegate/rdoc/SimpleDelegator.html). Wrap your objects with presenter classes that add display logic while keeping your models clean.

## Installation

Add to your Gemfile:

```ruby
gem 'resubject', '~> 1.0'
```

Requires Ruby >= 3.1 and ActiveSupport >= 7.2.

## Usage

Create a presenter by inheriting from `Resubject::Presenter`. All methods from the original object are available through delegation:

```ruby
class Box < Struct.new(:name, :items)
end

class BoxPresenter < Resubject::Presenter
  def contents
    items.join(', ')
  end
end
```

```ruby
box = Box.new('Awkward Package', ['platypus', 'sloth', 'anteater'])

presenter = BoxPresenter.new(box)
presenter.name     # => "Awkward Package" (delegated)
presenter.contents # => "platypus, sloth, anteater"
```

### Collections

Wrap a collection of objects with `Presenter.all`:

```ruby
boxes = [box1, box2, box3]
BoxPresenter.all(boxes)
# => [#<BoxPresenter>, #<BoxPresenter>, #<BoxPresenter>]
```

### Nested presenters

Use `presents` to automatically wrap associated objects:

```ruby
class PostPresenter < Resubject::Presenter
  presents :author                         # infers AuthorPresenter
  presents :comments, CommentPresenter     # explicit presenter class
end

post = PostPresenter.new(post)
post.author   # => #<AuthorPresenter>
post.comments # => [#<CommentPresenter>, ...]
```

Or use `present` inside a method for more control:

```ruby
class PostPresenter < Resubject::Presenter
  def comments
    present(to_model.comments, CommentPresenter)
  end
end
```

## Rails integration

Resubject includes a `present` helper in controllers and views automatically:

```ruby
class BoxesController < ApplicationController
  def index
    @boxes = present(Box.all)
  end

  def show
    @box = present(Box.find(params[:id]))
  end
end
```

The helper resolves the presenter class by convention (`Box` -> `BoxPresenter`). You can also specify the presenter explicitly:

```ruby
@boxes = present(Box.all, SpecialBoxPresenter)
```

Or stack multiple presenters:

```ruby
@boxes = present(Box.all, BoxPresenter, ExtendedBoxPresenter)
```

Use `present` directly in views:

```erb
<%= present(@box).contents %>
```

### ActionView helpers

Generate methods that delegate to ActionView helpers:

```ruby
class ProductPresenter < Resubject::Presenter
  currency :price, precision: 2
  percentage :discount
  time_ago :published_at
  date_format :created_at, :short
end
```

```ruby
product = ProductPresenter.new(product, view_context)
product.price        # => "$10.00"
product.discount     # => "25.000%"
product.published_at # => "about 1 hour"
product.created_at   # => "25 Dec 14:35"
```

| Method        | Maps to                | Source                              |
|---------------|------------------------|-------------------------------------|
| `currency`    | `number_to_currency`   | `ActionView::Helpers::NumberHelper` |
| `percentage`  | `number_to_percentage` | `ActionView::Helpers::NumberHelper` |
| `time_ago`    | `time_ago_in_words`    | `ActionView::Helpers::DateHelper`   |
| `date_format` | `to_fs`                | `ActiveSupport::TimeWithZone`       |

### Without Rails

Pass a template context manually when not using Rails:

```ruby
require 'action_view'

presenter = PostPresenter.new(post, ActionView::Base.empty)
```

## Testing

Resubject provides RSpec helpers that set up `subject` and `template` for specs in `spec/presenters/`:

```ruby
# spec/presenters/user_presenter_spec.rb
require 'resubject/rspec'

describe UserPresenter do
  let(:object) { double(:user, first: 'Jane', last: 'Doe') }

  it 'has full name' do
    expect(subject.name).to eq 'Jane Doe'
  end
end
```

The `subject` is automatically created as `described_class.new(object, template)`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes using [conventional commits](https://www.conventionalcommits.org/)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a Pull Request

## License

[MIT](LICENSE.txt)
