# frozen_string_literal: true

module PgsnapRails
  From = Struct.new(:columns, :sql, :table_name) do
    def join_expr_for(join_on)
      columns.find { |col| col.join_on == join_on }.column_expr
    end

    def join_ons
      columns.map(&:join_on).compact
    end

    def to_subquery
      "(#{sql}) #{table_name}"
    end
  end
end
