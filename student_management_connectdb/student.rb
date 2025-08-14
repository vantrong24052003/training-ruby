# frozen_string_literal: true

# format: rubocop -A student.rb
require_relative 'active_record'
require 'pry'

class Student
  include ActiveModel::Query

  attribute :ma_sv
  attribute :diem
  attribute :tuoi
  attribute :ten
end
