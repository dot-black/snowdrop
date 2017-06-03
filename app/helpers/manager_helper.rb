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

  def income_stats today_sales_statistic
    unless today_sales_statistic.infinite? || today_sales_statistic.nan?
      if today_sales_statistic > 0
        content_tag(:span, "(") +
        content_tag(:span, "+#{today_sales_statistic.to_i}%", class: "text-navy") +
        content_tag(:span, ")")
      else
        content_tag(:span, "(") +
        content_tag(:span, "#{today_sales_statistic.to_i}%", class: "text-danger") +
        content_tag(:span, ")")
      end
    end
  end

end
