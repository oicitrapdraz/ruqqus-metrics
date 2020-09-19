module ApplicationHelper
  include Pagy::Frontend

  def display_boolean(value)
    if value
      content_tag(:span, 'T', class: 'badge badge-success')
    else
      content_tag(:span, 'F', class: 'badge badge-danger')
    end
  end

  def display_number(number)
    if number.positive?
      content_tag(:span, "+#{number_with_delimiter number}", class: 'badge badge-success')
    elsif number.zero?
      content_tag(:span, 0, class: 'badge badge-secondary')
    else
      content_tag(:span, "-#{number_with_delimiter number}", class: 'badge badge-danger')
    end
  end
end
