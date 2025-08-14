# frozen_string_literal: true

# lib/my_calculator.rb
require_relative 'my_gem/version'

module MyGem
  class Error < StandardError; end

  class Calculator
    def add(a, b)
      a + b
    end

    def subtract(a, b)
      a - b
    end

    def multiply(a, b)
      a * b
    end

    def divide(a, b)
      raise Error, 'Không thể chia cho 0' if b.zero?

      a / b.to_f
    end
  end
end
