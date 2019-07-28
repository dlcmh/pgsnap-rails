# frozen_string_literal: true

module PgsnapRails
  class WhereAnd
    def initialize(ast)
      @ast = ast
    end

    def assign(column_name, operator, rhs = nil)
      return where.append("AND #{column_name} #{operator}") unless rhs

      lhs = [column_name, operator, ':rhs'].join(' ')
      rhs = { rhs: rhs }
      where.append([
        'AND', ActiveRecord::Base.sanitize_sql([
          [column_name, operator, ':rhs'].join(' '),
          rhs
        ])
      ].join(' '))
    end

    private

    def where
      @ast.where
    end
  end
end
