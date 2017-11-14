require 'smart_paginate'
require 'active_support'
require 'smart_pagination/version'

module SmartPagination
  extend ActiveSupport::Autoload

  # Autoload modules
  autoload :Renderer
  autoload :Helper
end

# Include action view helpers
if defined? ActionView::Base
  ActionView::Base.send :include, SmartPagination::Helper
end
