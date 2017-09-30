module ManagerHelper

  def current_page_name
    controller.controller_name.split("_").map(&:capitalize).join(" ")
  end

  def nav_link link_text, link_path, icons_class = '', method = :get
    class_name = current_page?(link_path) ? 'active' : ''
    link_class = icons_class.blank? ? '' : 'nav-label'
    content_tag :li, class: class_name do
      concat (
        link_to link_path, method: method do
          concat content_tag :i, '', class: icons_class if icons_class.present?
          concat content_tag :span, link_text, class: link_class
        end
      )
    end
  end

  def group_link link_text, controller, icons_class, &block
    class_name = params[:controller].delete('/').start_with?(controller.delete('/')) ? 'active' : ''
    content_tag :li, class: class_name do
      concat (
        link_to url_for(controller: controller, action: 'index') do
          concat content_tag :i, '', class: icons_class
          concat content_tag :span, link_text, class: 'nav-label'
          concat content_tag :span, '', class: 'fa arrow'
        end
      )
      block.call if block_given?
    end
  end

  def orders_status_links
    links_hash = {all: manager_orders_path(status: 'all')  }
    Order.statuses.keys.each { |status| links_hash[status] = manager_orders_path(status: status) }
    links_hash
  end

  def pending_orders_counter
    Order.where(status: 'pending').count
  end

  def products_categories_links
    links_hash = {
      all: manager_products_path,
      visible: manager_products_path(visible: "true"),
      hidden: manager_products_path(hidden: "true")
    }
    Category.all.each do |category|
      links_hash[category.slug.parameterize.to_sym] = manager_products_path(manager_category: category.id)
    end
    links_hash
  end

  def collapse_button button_title, button_class, target_id, target, &block
    concat button_tag button_title, class: button_class, data: { toggle: "collapse", target: "##{target_id}" }
    concat content_tag :br
    content_tag :ul, id: target_id, class: "list-group collapse" do
      target.each do |item|
        concat (
          content_tag :li, class: "list-group-item" do
            yield item
          end
        )
      end
    end
  end
end
