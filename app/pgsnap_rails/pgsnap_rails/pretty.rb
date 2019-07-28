# frozen_string_literal: true

module PgsnapRails
  class Pretty
    def initialize(to_sql)
      @to_sql = to_sql
    end

    def show
      puts formatted
      true
    end

    private

    def formatted
      @to_sql
        .gsub(/FROM \(SELECT/, "\nFROM (\n  SELECT")
        .gsub(/LEFT JOIN \(SELECT/, "\nLEFT JOIN (\n  SELECT")
        .gsub(/JOIN \(SELECT/, "\nJOIN (\n  SELECT")
        .gsub(/WHERE/, "\nWHERE")
        .gsub(/ON/, "\n  ON")
    end
  end
end
