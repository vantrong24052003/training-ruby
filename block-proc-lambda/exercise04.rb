# frozen_string_literal: true

# Bài tập 4: Xây dựng logger có cấu hình linh hoạt (Block, Proc và Lambda)
class FlexLogger
  def initialize
    @handlers = {}
  end

  def add_handler(name, filter: nil, formatter: nil, &block)
    @handlers[name] = { filter: filter, formatter: formatter, block: block }
  end

  def log(level, message)
    @handlers.each_value do |handler|
      next if handler[:filter] && !handler[:filter].call(message, level)

      formatted_message = handler[:formatter] ? handler[:formatter].call(message, level) : message
      handler[:block].call(formatted_message, level)
    end
  end

  def debug(message)
    log(:debug, message)
  end

  def info(message)
    log(:info, message)
  end

  def warn(message)
    log(:warn, message)
  end

  def error(message)
    log(:error, message)
  end
end

# Ví dụ cách sử dụng khi hoàn thành
logger = FlexLogger.new

# Thêm console handler bằng block
logger.add_handler('console') do |message, level|
  puts "[#{level.upcase}] #{message}"
end

# Thêm file handler với bộ lọc (chỉ log error) và định dạng riêng
only_errors = ->(_message, level) { level == :error }
timestamp_format = proc { |msg, lvl| "#{Time.now} [#{lvl.upcase}] #{msg}" }

logger.add_handler('file', filter: only_errors, formatter: timestamp_format) do |message, _level|
  File.open('error.log', 'a') do |file|
    file.puts message
  end
end

# Sử dụng logger
logger.debug 'Đây là debug message'
logger.info 'Ứng dụng đã khởi động'
logger.warn 'Cảnh báo: Disk space thấp'
logger.error 'Lỗi kết nối database!'
