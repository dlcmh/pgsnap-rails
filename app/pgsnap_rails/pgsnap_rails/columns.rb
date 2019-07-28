# frozen_string_literal: true

module PgsnapRails
  class Columns < Array
    def initialize(ast)
      @ast = ast
    end

    def assign
      concat @ast.most_recent_from_or_join__columns
      compact!
      flatten!
      uniq!(&:column_name)
    end
  end
end
