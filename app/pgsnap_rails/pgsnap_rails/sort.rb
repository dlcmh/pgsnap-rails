# frozen_string_literal: true

module PgsnapRails
  class Sort
    def initialize
      @str = nil
      @ascendings = []
      @ascendings = {}
    end

    def assign(*ascendings, **descendings)
      @ascendings = ascendings
      @descendings = descendings
      @str = "ORDER BY #{hsh.map { |ary| ary.join(' ') }.join(', ')}"
    end

    def clause
      @str
    end

    def inspect
      clause.inspect
    end

    private

    def hsh
      # https://stackoverflow.com/questions/2943422/
      #   in-ruby-how-do-i-make-a-hash-from-an-array/54023194#54023194
      @ascendings.to_h { |col| [col.to_s, 'ASC'] }
             .merge(
               @descendings.map { |key, val| [key.to_s, val.to_s.upcase] }
                           .to_h
             )
    end
  end
end
