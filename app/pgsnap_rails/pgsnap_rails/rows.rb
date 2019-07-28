# frozen_string_literal: true

module PgsnapRails
  class Rows
    attr_reader :class_name, :record, :sql

    def initialize(class_name, config)
      @class_name = class_name
      @record = Struct.new(*config.selectable_columns.map(&:to_sym))
      @sql = SelectStatement.new(config).result
    end

    def result
      rows
    end

    private

    def rows
      ActiveRecord::Base.connection.select_all(sql, class_name).rows.map { |row| record.new(*row) }
    end
  end
end
