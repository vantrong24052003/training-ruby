# frozen_string_literal: true

# Bài tập 2: Hệ thống retry với callback (Proc)
puts "\nBài tập 2: Hệ thống retry với callback (Proc)"
module Retryable
  def with_retry(max_attempts:, wait_time:, on_retry: nil, on_error: nil, on_success: nil)
    attempts = 0

    begin
      attempts += 1
      result = yield
      on_success&.call(result)
      result
    rescue StandardError => e
      if attempts < max_attempts
        on_retry&.call(attempts, e)
        sleep wait_time
        retry
      else
        on_error&.call(e)
        raise e
      end
    end
  end
end

include Retryable

on_retry_proc = proc { |attempt, exception| puts "Retry lần #{attempt} sau lỗi: #{exception.message}" }
on_error_proc = proc { |exception| puts "Thất bại sau tất cả các lần thử! Lỗi: #{exception.message}" }
on_success_proc = proc { |result| puts "Thành công! Kết quả: #{result}" }

result = with_retry(
  max_attempts: 3,
  wait_time: 1,
  on_retry: on_retry_proc,
  on_error: on_error_proc,
  on_success: on_success_proc
) do
  # Giả lập một API call không ổn định
  random = rand(10)
  raise 'Connection timeout' if random < 7

  'Dữ liệu từ API'
end

puts "Kết quả cuối cùng: #{result}"
