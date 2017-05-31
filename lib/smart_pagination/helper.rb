module SmartPagination
  module Helper
    # Render pagination links
    def smart_pagination_for(collection, options={})
      SmartPagination::Renderer.new(self, collection, options).render
    end

    # Alias helper method
    alias :pagination_for :smart_pagination_for
  end
end
