# frozen_string_literal: true

module PgsnapRails
  class JoinConstructs
    def initialize(ast)
      @ast = ast
      @tables = @ast.tables
    end

    def result
      return unless @tables.size >= 2

      @tables.each_cons(2).map do |both|
        lhs, rhs = both
        common = lhs.join_ons & rhs.join_ons - rhs.omitted_columns

        if common.blank?
          raise(
            ArgumentError,
            [
              'No common join found for',
              "#{lhs.table_name}, #{rhs.table_name}"
            ].join(' ')
          )
        end

        if common.size > 1 && !rhs.multi
          raise(
            ArgumentError,
            [
              "More than 1 common join found for tables",
              "#{[lhs.table_name, rhs.table_name].to_s} =>",
              common.to_s,
              %[\nSpecify `multi: true` on "#{rhs.table_name}" to proceed]
            ].join(' ')
          )
        end

        unless rhs.multi
          join = common.first
          if lhs.columns.select { |col| col.join_on == join }.size > 1
            raise(
              ArgumentError,
              "More than 1 possible join `#{join}` found for #{lhs.table_name}"
            )
          end
          [
            rhs.type, rhs.to_subquery,
            'ON', lhs.join_expr_for(join), '=', rhs.join_expr_for(join)
          ].join(' ')
        else
          joins = common.map do |join|
            if lhs.columns.select { |col| col.join_on == join }.size > 1
              raise(
                ArgumentError,
                "More than 1 possible join `#{join}` found" \
                " for #{lhs.table_name}"
              )
            end
            [
              lhs.join_expr_for(join), '=', rhs.join_expr_for(join)
            ].join(' ')
          end.join(' AND ')
          "#{rhs.type} #{rhs.to_subquery} ON #{joins}"
        end
      end
    end
  end
end
