# frozen_string_literal: true

module PgsnapRails
  class Distinct
    def initialize
      @bool = false
    end

    def assign
      @bool = true
    end

    def clause
      'DISTINCT' if @bool
    end

    def inspect
      @bool.inspect
    end
  end
end
