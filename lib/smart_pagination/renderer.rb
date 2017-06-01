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
          inner_window:    2,
          outer_window:    0
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

      # Get page numbers
      def page_numbers
        inner = @options[:inner_window].to_i
        outer = @options[:outer_window].to_i
        from  = current_page - inner
        to    = current_page + inner

        if to > total_pages
          from -= to - total_pages
          to    = total_pages
        end

        if from < 1
          to   += 1 - from
          from  = 1
          to    = total_pages if to > total_pages
        end

        middle = from..to

        if outer + 3 < middle.first
          left = (1..(outer + 1)).to_a
          left << :sep
        else
          left = 1...middle.first
        end

        if total_pages - outer - 2 > middle.last
          right = ((total_pages - outer)..total_pages).to_a
          right.unshift :sep
        else
          right = (middle.last + 1)..total_pages
        end

        left.to_a + middle.to_a + right.to_a
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

      # Render item separator
      def item_sep
        item_link '&hellip;', {}, class: "#{@options[:item_class]} #{@options[:disabled_class]}".strip
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
        wrap_tag = tag wrapper, wrap_tag, wrap_opt if wrapper.present?

        wrap_tag
      end

      # Render pager
      def pager
        items = [previous_link, next_link]
        wrapper items.map(&:to_s).join
      end

      # Render pagination
      def pagination
        items = page_numbers.map { |page| page == :sep ? item_sep : page_link(page) }
        items = [previous_link, *items, next_link]

        wrapper items.map(&:to_s).join
      end
  end
end
