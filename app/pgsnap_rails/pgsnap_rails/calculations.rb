# frozen_string_literal: true

module PgsnapRails
  class Calculations
    def initialize(parser)
      @parser = parser
    end

    # https://math.stackexchange.com/questions/975541/
    #   what-are-the-formal-names-of-operands-and-results-for-basic-operations
    def c_div(dividend, divisor, col_alias, digits = 2)
      calc("ROUND(#{dividend} / #{divisor}::numeric, #{digits})", col_alias)
    end

    def c_minus(minuend, subtrahend, col_alias)
      calc("(#{minuend} - #{subtrahend})", col_alias)
    end

    def calc(expr, col_alias)
      @parser.column("#{expr} #{col_alias}")
    end
  end
end
