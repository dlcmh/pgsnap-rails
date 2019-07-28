# frozen_string_literal: true

module PgsnapRails
  class Limit
    def initialize
      @str = nil
    end

    def assign(num)
      @str = "LIMIT #{num}"
    end

    def clause
      @str
    end

    def inspect
      clause.inspect
    end
  end
end
