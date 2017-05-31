require 'smart_paginate'
require 'smart_pagination/version'
require 'smart_pagination/helper'
require 'smart_pagination/renderer'

module SmartPagination
  class << self
    def included(model_class)
      model_class.send :include, SmartPaginate
    end
  end
end

if defined? ActionView::Base
  ActionView::Base.send :include, SmartPagination::Helper
end
