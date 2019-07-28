# frozen_string_literal: true

module PgsnapRails
  Join = Struct.new(:type, :table_name, :sql, :omitted_columns, :columns,
                    :multi, :on) do
    def initialize(ast, method, model, opts)
      @ast = ast
      assign(method, model, opts)
    end

    def assign(method, model, opts)
      assign_from(model)
      self.multi = opts[:multi]
      self.omitted_columns = Array(opts[:omit]).map(&:to_s)
      self.on = opts[:on].to_s
      self.type = JoinType.from(method)
    end

    def join_expr_for(join_on)
      result = columns.select { |col| col.join_on == join_on }

      return result.first.column_expr unless result.size > 1

      if on.blank?
        raise(
          ArgumentError,
          "More than 1 possible join `#{join_on}` found for #{table_name}"
        )
      else
        result.find { |col| col.column_name == on }.column_expr
      end
    end

    def join_ons
      columns.map(&:join_on).compact
    end

    def to_subquery
      "(#{sql}) #{table_name}"
    end

    private

    def assign_from(model)
      self.table_name = model.table_name
      self.sql = model.to_sql
      self.columns = model.top_level_columns.map do |col|
        Column.new(@ast, col).assign
      end
    end
  end
end
