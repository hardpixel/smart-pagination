module SmartPagination
  class Renderer
    # Initialize pagination renderer
    def initialize(context, collection, options={})
      @context    = context
      @collection = collection
      @options    = default_options.merge(options)
    end

    # Render pagination links
    def render
      pager_mode? ? pager : pagination
    end

    private

      # Default options
      def default_options
        {
          pager_mode:     false,
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
          items_left:     3,
          items_right:    3
        }
      end

      # Get current_page
      def current_page
        @collection.current_page.to_i
      end

      # Get total pages
      def total_pages
        @total_pages ||= @collection.total_pages
      end

      # Check if current page
      def current_page?(page)
        page.to_i == current_page
      end

      # Check if pager mode enabled
      def pager_mode?
        @options[:pager_mode].present?
      end

      # Check if all items visible
      def all_visible?
        total_pages <= @options[:items_left].to_i + @options[:items_right].to_i
      end

      # Page link
      def page_link(page)
        params  = { page: page }
        active  = @options[:active_class] if current_page? page
        options = { class: "#{@options[:item_class]} #{active}".strip }

        item_link page, params, options
      end

      # Previous link
      def previous_link
        text     = @options[:previous_text]
        params   = { page: @collection.previous_page }
        disabled = @options[:disabled_class] unless @collection.previous_page?
        options  = { class: "#{@options[:item_class]} #{@options[:previous_class]} #{disabled}".strip }

        item_link text, params, options
      end

      # Next link
      def next_link
        text     = @options[:next_text]
        params   = { page: @collection.next_page }
        disabled = @options[:disabled_class] unless @collection.next_page?
        options  = { class: "#{@options[:item_class]} #{@options[:next_class]} #{disabled}".strip }

        item_link text, params, options
      end

      # Render item link
      def item_link(text, params={}, html_options={})
        wrapper  = @options[:item_wrapper]
        link_opt = html_options if wrapper.blank?
        item_tag = link_to text, params, link_opt
        item_tag = tag wrapper, item_tag, html_options if wrapper.present?

        item_tag
      end

      # Render items left
      def items_left
        items = @options[:items_left].to_i
        items = total_pages if all_visible?

        items.times.map { |page| page_link(page + 1) }.join
      end

      # Render items right
      def items_right
        return if all_visible?

        left  = @options[:items_left].to_i
        right = @options[:items_right].to_i
        items = total_pages - left

        items.times.map { |page| page_link(page + 1 + right) }.join
      end

      # Render items separator
      def items_sep
        return if all_visible?
        item_link '...', {}, class: "#{@options[:item_class]} #{@options[:disabled_class]}".strip
      end

      # Render content tag
      def tag(*args, &block)
        @context.content_tag(*args, &block)
      end

      # Render link tag
      def link_to(text, params={}, html_options={})
        url = @context.url_for params.merge(per_page: @collection.per_page)
        opt = html_options.to_h

        opt.merge!(href: url) if params[:page].present?
        tag :a, "#{text}".html_safe, opt
      end

      # Render wrapper
      def wrapper(links)
        wrapper  = @options[:wrapper]
        wrap_opt = { class: @options[:wrapper_class] }
        wrap_tag = links.html_safe
        wrap_tag = tag wrapper, links, wrap_opt if wrapper.present?

        wrap_tag
      end

      # Render pager
      def pager
        items = [previous_link, next_link]
        wrapper items.map(&:to_s).join
      end

      # Render pagination
      def pagination
        items = [previous_link, items_left, items_sep, items_right, next_link]
        wrapper items.map(&:to_s).join
      end
  end
end
