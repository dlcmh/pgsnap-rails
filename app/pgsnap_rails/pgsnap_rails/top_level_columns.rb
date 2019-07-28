# frozen_string_literal: true

module PgsnapRails
  class TopLevelColumns
    Column = Struct.new(:column_expr, :column_name, :join_on, :table_name)

    def initialize(ast)
      @ast = ast
    end

    def result
      return columns unless top_level_column_names.present?

      top_level_column_names.map do |name|
        columns.find { |col| col.column_name == name } ||
        Column.new(
          "#{table_name}.#{name}",
          name,
          nil,
          table_name
        )
      end
    end

    private

    def columns
      @ast.columns
    end

    def table_name
      @ast.table_name
    end

    def top_level_column_names
      @ast.top_level_column_names
    end
  end
end
