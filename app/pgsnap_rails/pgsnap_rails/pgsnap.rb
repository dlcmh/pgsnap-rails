# frozen_string_literal: true

module PgsnapRails
  class Pgsnap
    include Enumerable

    extend PgsnapClassMethods
    include PgsnapDelegations

    def each(&blk)
      all.each(&blk)
    end

    def ast
      @ast ||= Ast.new
    end

    def klass
      'pgsnap_instance'
    end

    def main_built
      build_main
    end

    def top_level_columns
      @top_level_columns ||= TopLevelColumns.new(ast).result
    end

    private

    def aggregates
      @aggregates ||= Aggregates.new(parser)
    end

    def build_main
      ast.pgsnap_instance = self
      ast.table_name = class_name_underscored
      main
      compile
      self
    end

    def class_name
      self.class.name
    end

    def class_name_underscored
      class_name.underscore
    end

    def calculations
      @calculations ||= Calculations.new(parser)
    end

    def compiler
      @compiler ||= Compiler.new(ast)
    end

    def parser
      @parser ||= Parser.new(ast)
    end

    def post_compilation_parser
      @post_compilation_parser ||= PostCompilationParser.new(ast)
    end

    def set_operations
      @set_operations ||= SetOperations.new(parser)
    end

    def sql
      @sql ||= Sql.new(ast)
    end

    def sql_runner
      SqlRunner.new(to_sql, class_name)
    end
  end
end
