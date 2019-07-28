# frozen_string_literal: true

module PgsnapRails
  class Parser
    def initialize(ast)
      @ast = ast
    end

    def aggregate_column(expr, column_alias)
      @ast.aggregate_columns.assign(expr, column_alias)
      @ast.selects.assign(@ast.aggregate_columns.last)
      @ast.top_level_column_names.assign(column_alias)
    end

    def column(column_expr)
      @ast.selects.assign(column_expr)
      @ast.top_level_column_names.assign(column_expr.to_s.split.last)
    end

    def distinct
      @ast.distinct.assign
    end

    def from(*args)
      AssignFrom.new(@ast, *args).assign
      @ast.column_names.assign
      @ast.columns.assign
    end

    def join(*args)
      @ast.joins.assign(__method__, *args)
      @ast.column_names.assign
      @ast.columns.assign
    end

    def left_join(*args)
      @ast.joins.assign(__method__, *args)
      @ast.column_names.assign
      @ast.columns.assign
    end

    def select_all_columns
      @ast.column_names.each { |name| column(name) }
    end

    def union(*args)
      @ast.sets.assign(__method__, *args)
    end

    def where(*args)
      @ast.where.assign(*args)
    end

    def where_and(*args)
      @ast.where_and.assign(*args)
    end
  end
end
