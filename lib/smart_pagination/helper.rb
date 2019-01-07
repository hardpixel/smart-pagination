module SmartPagination
  module Helper
    def smart_pagination_for(collection, options = {})
      SmartPagination::Renderer.new(self, collection, options).render
    end

    alias :pagination_for :smart_pagination_for

    def smart_pager_for(collection, options = {})
      options = options.merge(pager_mode: true)
      SmartPagination::Renderer.new(self, collection, options).render
    end

    alias :pager_for :smart_pager_for

    def smart_pagination_info_for(collection, options = {})
      options = options.merge(info_mode: true)
      SmartPagination::Renderer.new(self, collection, options).render
    end

    alias :pagination_info_for :smart_pagination_info_for
  end
end
