# frozen_string_literal: true

class CacheUtils
  def generate_cache_key(controller_path, action_name, params)
    cache_suffix = "#{controller_path.gsub('/', '_')}_#{action_name}"
    cache_key = (params.to_h.select { |_key, value| value.present? }.sort.map { |key, value| "#{key}=#{value}" }).join('&')

    [cache_suffix, cache_key].select(&:present?).join('_')
  end
end
