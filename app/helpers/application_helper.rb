module ApplicationHelper
  include Pagy::Frontend

  def title(text)
    content_for :title, text
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end

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

  def display_guild_logo(guild, max_size)
    if guild.logo_path
      image_tag(guild.logo_path, style: "max-width: #{max_size}px; max-height: #{max_size}px; border-radius: #{max_size / 2}px; border: 2px solid #73AD21;")
    else
      image_tag('/guild_logos/0', style: "max-width: #{max_size}px; max-height: #{max_size}px; border-radius: #{max_size / 2}px; border: 2px solid #73AD21;")
    end
  end
end
