# frozen_string_literal: true

module PgsnapRails
  class Selects < Array
    def initialize(ast)
      @ast = ast
    end

    def assign(column_expr)
      self << column_expr.to_s
    end

    def clause
      join(', ')
    end

    def column_names
      map(&:split).map(&:last) if present?
    end

    def select_all_columns
      raise(ArgumentError, 'specify `from` first') unless @ast.from.present?

      concat @ast.column_names
    end
  end
end
