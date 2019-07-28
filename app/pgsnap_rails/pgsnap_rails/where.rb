# frozen_string_literal: true

module PgsnapRails
  class Where
    def initialize
      @str = nil
    end

    def append(where_and_clause)
      @str += " #{where_and_clause}"
    end

    def assign(column_name, operator, rhs = nil)
      return @str = "WHERE #{column_name} #{operator}" unless rhs

      lhs = [column_name, operator, ':rhs'].join(' ')
      rhs = { rhs: rhs }
      @str = [
        'WHERE', ActiveRecord::Base.sanitize_sql([
          [column_name, operator, ':rhs'].join(' '),
          rhs
        ])
      ].join(' ')
    end

    def clause
      @str
    end

    def inspect
      clause.inspect
    end
  end
end
