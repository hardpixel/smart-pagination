module SmartPagination
  module Helper
    # Render pagination links
    def smart_pagination_for(collection, options={})
      SmartPagination::Renderer.new(self, collection, options).render
    end

    # Alias helper method
    alias :pagination_for :smart_pagination_for

    # Render pager links
    def smart_pager_for(collection, options={})
      options = options.merge(pager_mode: true)
      SmartPagination::Renderer.new(self, collection, options).render
    end

    # Alias helper method
    alias :pager_for :smart_pager_for
  end
end
