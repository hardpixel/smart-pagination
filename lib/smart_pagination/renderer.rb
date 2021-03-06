module SmartPagination
  class Renderer
    def initialize(context, collection, options = {})
      @context    = context
      @collection = collection
      @options    = default_options.merge(options)
    end

    def render
      if auto_hide?
        nil
      elsif info_mode?
        pagination_info
      elsif pager_mode?
        pager
      else
        pagination
      end
    end

    private

    def default_options
      {
        info_mode:      false,
        pager_mode:     false,
        auto_hide:      false,
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

    def collection_name
      if @collection.is_a? ActiveRecord::Relation
        @collection.model_name.human(count: total_entries)
      else
        total_entries == 1 ? 'Item' : 'Items'
      end
    end

    def current_page
      @collection.current_page.to_i
    end

    def total_pages
      @total_pages ||= @collection.total_pages.to_i
    end

    def current_page?(page)
      page.to_i == current_page
    end

    def per_page
      @collection.per_page.to_i
    end

    def current_entries
      entries = current_page * per_page
      entries < total_entries ? entries : total_entries
    end

    def total_entries
      @total_entries ||= @collection.total_entries.to_i
    end

    def auto_hide?
      @options[:auto_hide].present? && total_pages < 2
    end

    def pager_mode?
      @options[:pager_mode].present?
    end

    def info_mode?
      @options[:info_mode].present?
    end

    def url_params
      url    = URI.parse(@context.request.url)
      params = Rack::Utils.parse_nested_query(url.query).symbolize_keys

      params.except(:page)
    end

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

    def link_params(page)
      page = @collection.send(:"#{page}_page") unless page.is_a? Integer
      { page: page }
    end

    def link_options(page)
      if page.is_a? Integer
        active = @options[:active_class] if current_page? page
        { class: "#{@options[:item_class]} #{active}".strip }
      else
        disabled   = @options[:disabled_class] unless @collection.send(:"#{page}_page").present?
        item_class = @options[:"#{page}_class"]

        { class: "#{@options[:item_class]} #{item_class} #{disabled}".strip }
      end
    end

    def page_link(page)
      item_link page, link_params(page), link_options(page)
    end

    def previous_link
      item_link @options[:previous_text], link_params(:previous), link_options(:previous)
    end

    def next_link
      item_link @options[:next_text], link_params(:next), link_options(:next)
    end

    def item_link(text, params = {}, html_options = {})
      wrapper  = @options[:item_wrapper]
      link_opt = html_options if wrapper.blank?
      item_tag = link_to text, params, link_opt
      item_tag = tag wrapper, item_tag, html_options if wrapper.present?

      item_tag
    end

    def item_sep
      item_link '&hellip;', {}, class: "#{@options[:item_class]} #{@options[:disabled_class]}".strip
    end

    def tag(*args, &block)
      @context.content_tag(*args, &block)
    end

    def link_to(text, params = {}, html_options = {})
      prm = params.except(:page) if params[:page] == 1
      url = @context.url_for url_params.merge(prm || params)
      opt = html_options.to_h
      opt = opt.merge(href: url) if params[:page].present?

      tag :a, "#{text}".html_safe, opt
    end

    def wrapper(links)
      wrapper  = @options[:wrapper]
      wrap_opt = { class: @options[:wrapper_class] }
      wrap_tag = links.html_safe
      wrap_tag = tag wrapper, wrap_tag, wrap_opt if wrapper.present?

      wrap_tag
    end

    def pagination_info
      current = tag :strong, current_entries, class: 'current'
      total   = tag :strong, total_entries, class: 'total'

      "Displaying #{current} of #{total} #{collection_name}".html_safe
    end

    def pager
      items = [previous_link, next_link]
      wrapper items.map(&:to_s).join
    end

    def pagination
      items = page_numbers.map { |page| page == :sep ? item_sep : page_link(page) }
      items = [previous_link, *items, next_link]

      wrapper items.map(&:to_s).join
    end
  end
end
