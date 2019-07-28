# frozen_string_literal: true

module PgsnapRails
  class SetOperations
    def initialize(parser)
      @parser = parser
    end

    def union(model)
      @parser.union(model)
    end
  end
end
