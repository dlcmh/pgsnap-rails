# frozen_string_literal: true

module PgsnapRails
  class GroupBy
    def initialize(ast)
      @ast = ast
      @column_names_to_group_by = nil
    end

    def assign
      return unless aggregate_columns.present?

      @column_names_to_group_by = (selects || column_names) - aggregate_columns
    end

    def clause
      return unless @column_names_to_group_by.present?

      ['GROUP BY', @column_names_to_group_by.join(', ')].join(' ')
    end

    def inspect
      @column_names_to_group_by.inspect
    end

    private

    def aggregate_columns
      @ast.aggregate_columns
    end

    def column_names
      @ast.column_names.presence
    end

    def selects
      @ast.selects.presence
    end
  end
end
