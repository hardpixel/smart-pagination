require 'smart_pagination/version'

module SmartPagination
  autoload Render, 'smart_pagination/renderer'

  # Render pagination links
  def smart_pagination_for(collection, options={})
    SmartPagination::Renderer.new(collection, options).render
  end

  # Alias helper method
  alias :pagination_for :smart_pagination_for
end

if defined? ActionView::Base
  # Include action view helpers
  ActionView::Base.send :include, SmartPagination
end
