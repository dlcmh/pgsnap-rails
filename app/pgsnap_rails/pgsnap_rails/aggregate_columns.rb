# frozen_string_literal: true

module PgsnapRails
  class AggregateColumns < Array
    def initialize(ast)
      @ast = ast
    end

    def assign(expr, column_alias)
      self << [expr, column_alias].join(' ')
    end
  end
end
