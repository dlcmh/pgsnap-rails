# frozen_string_literal: true

module PgsnapRails
  class TopLevelColumnNames < Array
    def initialize(ast)
      @ast = ast
    end

    def assign(column_name_to_retain)
      self << column_name_to_retain.to_s
      compact!
      flatten!
      uniq!
    end
  end
end
