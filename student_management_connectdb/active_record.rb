# frozen_string_literal: true

require_relative 'database'
require 'pry'

# This module provides querying capabilities for ActiveModel objects
module ActiveModel
  # The Query module adds class and instance methods for querying records
  module Query
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        include InstanceMethods

        @records = []
      end
    end

    # This module contains class-level querying methods
    module ClassMethods
      attr_reader :records

      def attribute(name)
        define_method(name) do
          @attributes[name] # getter
        end

        define_method("#{name}=") do |value|
          @attributes[name] = value # setter
        end
      end

      def create(attributes = {})
        record = new
        record.instance_variable_set(:@attributes, attributes)
        @records << record
        save_to_db(record)
        record
      end

      def all
        load_from_db
        @records
      end

      def where(conditions)
        load_from_db
        @records.select do |record|
          conditions.to_a.all? { |key, value| record.send(key) == value }
        end
      end

      def find(ma_sv)
        load_from_db
        @records.find { |record| record.ma_sv == ma_sv }
      end

      def first
        load_from_db
        @records.first
      end

      def last
        load_from_db
        @records.last
      end

      private

      def save_to_db(record)
        Database::DB.execute(
          'INSERT INTO student (ma_sv, ten, tuoi, diem) VALUES (?, ?, ?, ?)',
          [record.ma_sv, record.ten, record.tuoi, record.diem]
        )
      end

      def load_from_db
        @records = Database::DB.execute('SELECT * FROM student').map do |row|
          new(row['ma_sv'], row['ten'], row['tuoi'], row['diem']).tap do |record|
            record.instance_variable_set(:@attributes, {
                                           ma_sv: row['ma_sv'],
                                           ten: row['ten'],
                                           tuoi: row['tuoi'],
                                           diem: row['diem']
                                         })
          end
        end
      end
    end

    # This module contains instance-level methods for managing records
    module InstanceMethods
      def initialize(*)
        Database.init
        @attributes = {}
      end

      def destroy
        self.class.records.delete(self)
        Database::DB.execute('DELETE FROM student WHERE ma_sv = ?', [ma_sv])
      end
    end
  end
end
