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

  def display_guild_logo(guild)
    if guild.data
      profile_url = guild.data['profile_url'].start_with?('/assets/') ? 'logo.png' : guild.data['profile_url']

      image_tag(profile_url, style: 'max-width: 50px; max-height: 50px; border-radius: 25px; border: 2px solid #73AD21;')
    else
      content_tag(:i, class: 'fas fa-users')
    end
  end
end
