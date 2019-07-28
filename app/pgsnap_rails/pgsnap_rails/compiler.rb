# frozen_string_literal: true

module PgsnapRails
  class Compiler
    def initialize(ast)
      @ast = ast
    end

    def compile
      @ast.group_by.assign
      @ast.compilation_done
    end
  end
end
