# frozen_string_literal: true

module PgsnapRails
  class ColumnNames < Array
    def initialize(ast)
      @ast = ast
    end

    def assign
      concat @ast.most_recent_from_or_join__columns.map(&:column_name)
      compact!
      flatten!
      uniq!
    end
  end
end
