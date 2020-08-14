# frozen_string_literal: true

class Logg
  def self.info(message)
    Rails.logger.info("INFO: #{message}")
  end

  def self.error(error)
    Rails.logger.error ["ERROR: #{error.message}", *error.backtrace].join($INPUT_RECORD_SEPARATOR)
  end
end
