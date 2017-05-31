module SmartPagination
  class Renderer
    # Initialize pagination renderer
    def initialize(collection, options={})
      @collection = collection
      @options    = default_options.merge(options)
    end

    # Render pagination links
    def render

    end

    private

      # Default options
      def default_options
        {}
      end
  end
end
