# frozen_string_literal: true

module PgsnapRails
  class Sql
    def initialize(ast)
      @ast = ast
    end

    def pretty
      Pretty.new(to_sql).show
    end

    def to_sql
      level_a = if selects_clause
                  [
                    'SELECT', @ast.distinct.clause, selects_clause,
                    "FROm (#{to_sql_clause}) to_sql_clause",
                    @ast.group_by.clause
                  ].compact.join(' ')
                else
                  to_sql_clause
                end

      if filter_clause || limit_clause || sort_clause
        [
          "SELECT * FROM (#{level_a}) level_a",
          filter_clause,
          sort_clause,
          limit_clause
        ].compact.join(' ')
      else
        level_a
      end
    end

    private

    def columns__column_expr
      @ast.columns.map(&:column_expr).join(', ')
    end

    def base_sql
      if join_constructs
        [
          select_construct,
          "FroM #{@ast.from.to_subquery}",
          join_constructs
        ].join(' ')
      else
        @ast.from.sql
      end
    end

    def filter_clause
      @filter_clause ||= @ast.filter.clause.presence
    end

    def with_additional_clauses_sql
      return unless where_clause

      [base_sql, where_clause].join(' ')
    end

    def with_sets_only
      return unless sets_clause && where_clause.blank?

      [
        base_sql,
        sets_clause
      ].join(' ')
    end

    def sorts_sets_clauses_groups_sql
      unless where_clause && (
        sets_clause || base_sql.match(/UNION|INTERSECT|MINUS|ORDER BY|GROUP BY/)
      )
        return
      end

      [
        'SELECT * froM',
        "(#{[base_sql, sets_clause].compact.join(' ')}) sscg",
        where_clause
      ].join(' ')
    end

    def join_constructs
      @join_constructs ||= JoinConstructs.new(@ast).result
    end

    def limit_clause
      @limit_clause ||= @ast.limit.clause.presence
    end

    def sort_clause
      @sort_clause ||= @ast.sort.clause.presence
    end

    def to_sql_clause
      sorts_sets_clauses_groups_sql \
      || with_additional_clauses_sql \
      || with_sets_only \
      || base_sql
    end

    def select_construct
      ['SELECT', columns__column_expr].compact.join(' ')
    end

    def selects_clause
      @selects_clause ||= @ast.selects.clause.presence
    end

    def sets_clause
      @sets_clause ||= @ast.sets.clause.presence
    end

    def where_clause
      @where_clause ||= @ast.where.clause.presence
    end
  end
end
