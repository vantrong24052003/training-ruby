# lib/string_utils.rb
require_relative "string_utils/version"

module StringUtils
  class Error < StandardError; end

  # Chuyển đổi chuỗi thành dạng snake_case
  def self.to_snake_case(str)
    str.gsub(/::/, '/')
       .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
       .gsub(/([a-z\d])([A-Z])/, '\1_\2')
       .tr("-", "_")
       .downcase
  end

  # Chuyển đổi chuỗi thành dạng camelCase
  def self.to_camel_case(str)
    str.split('_').collect.with_index { |word, i|
      i == 0 ? word : word.capitalize
    }.join
  end

  # Đảo ngược chuỗi
  def self.reverse(str)
    str.reverse
  end

  # Đếm số từ trong chuỗi
  def self.word_count(str)
    str.split(/\s+/).length
  end
end