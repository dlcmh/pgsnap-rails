# frozen_string_literal: true

module PgsnapRails
  class Aggregates
    def initialize(parser)
      @parser = parser
    end

    def c_count(column_name, column_alias)
      @parser.aggregate_column("COUNT(#{column_name})", column_alias)
    end

    def c_max(column_name, column_alias)
      @parser.aggregate_column("MAX(#{column_name})", column_alias)
    end

    def c_sum(column_name, column_alias)
      @parser.aggregate_column("SUM(#{column_name})", column_alias)
    end
  end
end
