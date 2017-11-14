require 'smart_paginate'
require 'active_support'
require 'smart_pagination/version'

module SmartPagination
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  # Autoload modules
  autoload :Renderer
  autoload :Helper

  included do
    include SmartPaginate
  end
end

# Include action view helpers
if defined? ActionView::Base
  ActionView::Base.send :include, SmartPagination::Helper
end
