# SmartPagination

SmartPagination adds view helpers for SmartPaginate. A simple, smart and clean pagination extension for Active Record and plain Ruby Arrays:

- **Simple:** Easy to use, with a simple interface. It just does pagination, nothing more.
- **Smart:** Can navigate through the pages without having to do an expensive count query. SmartPaginate will actually fetch one record more than needed and use it to determine if there's a next page.
- **Clean:** The code is as minimal as possible while still useful. SmartPaginate does not auto include itself or monkey patch any classes.

For more details you can check SmartPaginate at https://github.com/ppostma/smart_paginate.

[![Gem Version](https://badge.fury.io/rb/smart_pagination.svg)](https://badge.fury.io/rb/smart_pagination)
[![Build Status](https://travis-ci.org/hardpixel/smart-pagination.svg?branch=master)](https://travis-ci.org/hardpixel/smart-pagination)
[![Code Climate](https://codeclimate.com/github/hardpixel/smart-pagination/badges/gpa.png)](https://codeclimate.com/github/hardpixel/smart-pagination)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smart_pagination'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smart_pagination

## Usage

To enable pagination in an Active Record model, include the `SmartPagination` or `SmartPaginate` concern in your class:

```ruby
class User < ActiveRecord::Base
  include SmartPagination
end
```

Then you can use the paginate scope to paginate results:

```ruby
@users = User.paginate(page: params[:page], per_page: params[:per_page])
```

And finally you can use the `smart_pagination_for` or `pagination_for` helper in your views to render the pagination links:

```erb
<%= smart_pagination_for(@users) %>
```

If you want to render only previous and next links, you can use the `smart_pager_for` or `pager_for` helper in your views:

```erb
<%= smart_pager_for(@users) %>
```

If you want to render the pagination information text (Displaying x of y Items), you can use the `smart_pagination_info_for` or `pagination_info_for` helper in your views:

```erb
<%= smart_pagination_info_for(@users) %>
```

There are a number of options you can use to customize the pagination links. The default options are:

```ruby
options = {
  info_mode:      false,
  pager_mode:     false,
  auto_hide:      false,
  item_class:     '',
  previous_text:  '&laquo;',
  previous_class: 'previous',
  next_text:      '&raquo;',
  next_class:     'next',
  active_class:   'active',
  disabled_class: 'disabled',
  wrapper:        'ul',
  wrapper_class:  'pagination',
  item_wrapper:   'li',
  inner_window:    2,
  outer_window:    0
}

smart_pagination_for(@users, options)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hardpixel/smart-pagination. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SmartPagination project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hardpixel/smart-pagination/blob/master/CODE_OF_CONDUCT.md).
