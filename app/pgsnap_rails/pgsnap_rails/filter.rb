# frozen_string_literal: true

module PgsnapRails
  class Filter
    def initialize
      @str = nil
    end

    def assign(column_name, operator, rhs)
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
