# frozen_string_literal: true

module PgsnapRails
  class PostCompilationParser
    def initialize(ast)
      @ast = ast
    end

    def filter(*args)
      @ast.filter.assign(*args)
      pgsnap_instance
    end

    def limit(*args)
      @ast.limit.assign(*args)
      pgsnap_instance
    end

    def sort(*args)
      @ast.sort.assign(*args)
      pgsnap_instance
    end

    private

    def pgsnap_instance
      @ast.pgsnap_instance
    end
  end
end
