# frozen_string_literal: true

module PgsnapRails
  Column = Struct.new(:column_expr, :column_name, :join_on, :table_name) do
    def initialize(ast, col)
      @ast = ast
      @col = col
    end

    def assign
      self.column_expr = "#{@col.table_name}.#{@col.column_expr.split('.')[1]}"
      self.column_name = @col.column_name
      self.join_on = @col.join_on
      self.table_name = @ast.table_name
      self
    end
  end
end
