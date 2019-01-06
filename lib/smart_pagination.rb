require 'smart_paginate'
require 'active_support'
require 'smart_pagination/version'

module SmartPagination
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  autoload :Renderer
  autoload :Helper

  included do
    include SmartPaginate
  end
end

if defined? ActionView::Base
  ActionView::Base.send :include, SmartPagination::Helper
end
