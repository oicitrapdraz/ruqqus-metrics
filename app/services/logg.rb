# frozen_string_literal: true

class Logg
  def self.error(error)
    Rails.logger.error ["ERROR: #{error.message}", *error.backtrace].join($INPUT_RECORD_SEPARATOR)
  end
end
