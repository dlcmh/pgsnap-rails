# frozen_string_literal: true

module PgsnapRails
  class SqlRunner
    def initialize(sql, class_name)
      @class_name = class_name
      @sql = sql

      @record = Struct.new(*columns.map(&:to_sym))
    end

    def all
      rows
    end

    private

    def columns
      results.columns
    end

    def results
      @results ||= ActiveRecord::Base.connection.select_all(@sql, @class_name)
    end

    def rows
      results.rows.map { |row| @record.new(*row) }
    end
  end
end
