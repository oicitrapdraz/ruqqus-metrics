# frozen_string_literal: true

class CacheUtils
  def generate_cache_key(controller_path, action_name, params)
    cache_suffix = "#{controller_path.gsub('/', '_')}_#{action_name}"
    cache_key = (params.to_h.sort.map { |key, value| "#{key}=#{value}" }).join('&')

    "#{cache_suffix}_#{cache_key}"
  end
end
