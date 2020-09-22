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

  def display_guild_logo(guild, max_size)
    if guild.data && guild.data['profile_url']
      profile_url = guild.data['profile_url'].start_with?('/assets/') ? 'logo.png' : guild.data['profile_url']

      image_tag(profile_url, style: "max-width: #{max_size}px; max-height: #{max_size}px; border-radius: #{max_size / 2}px; border: 2px solid #73AD21;")
    else
      image_tag('logo.png', style: "max-width: #{max_size}px; max-height: #{max_size}px; border-radius: #{max_size / 2}px; border: 2px solid #73AD21;")
    end

    content_tag(:i, '', class: 'fa fa-users')
  end
end
