# frozen_string_literal: true

module PgsnapRails
  class ArModel
    Column = Struct.new(
      :column_expr,
      :column_name,
      :join_on,
      :table_name,
      keyword_init: true
    )

    attr_reader :ar_model, :columns, :enum_model

    def initialize(model, enum_column = nil, only_columns = nil)
      @ar_model = ArModelWrapper.new(model, enum_column, only_columns)
      @enum_model = EnumModel.new(model, enum_column) if enum_column
      setup_columns
    end

    def aggregate_columns
      @aggregate_columns ||= [
        ar_model,
        enum_model
      ].compact.map(&:columns).flatten
    end

    def joinable_columns
      all_joinable_columns.uniq(&:column_name)
    end

    def column_names
      @column_names ||= columns.map(&:column_name)
    end

    def subquery_expr
      "(#{to_sql}) #{table_name}"
    end

    def table_name
      ar_model.table_name
    end

    def to_sql
      if enum_model
        [
          'SELECT', columns_to_select,
          'FroM', ar_model.subquery_expr,
          left_join_enum_model_clause
        ].compact.join(' ')
      else
        ar_model.to_sql
      end
    end

    def top_level_columns
      columns
    end

    private

    def all_joinable_columns
      aggregate_columns.select { |e| e.type.in? %i[enum fk pk] }
    end

    def ar_model_joins
      aggregate_columns.select do |e|
        e.is_a?(PgsnapRails::ArModelWrapper::Column) && e.type.in?(%i[enum fk pk])
      end
    end

    def columns_to_select
      aggregate_columns.uniq(&:column_name).map(&:column_expr).join(', ')
    end

    def enum_model_joins
      aggregate_columns.select do |e|
        e.is_a?(PgsnapRails::EnumModel::Column) && e.type.in?(%i[fk pk])
      end
    end

    def join_equality
      common = (ar_model_joins.pluck(:join_on) & enum_model_joins.pluck(:join_on)).tap do |obj|
        raise(ArgumentError, 'More than 1 join found') if obj.size > 1
      end.first

      [
        ar_model_joins.find { |e| e.join_on == common }.column_expr,
        '=',
        enum_model_joins.find { |e| e.join_on == common }.column_expr
      ].join(' ')
    end

    def left_join_enum_model_clause
      return unless enum_model

      [
        'LEFT JOIN',
        enum_model.subquery_expr,
        'ON',
        join_equality
      ].join(' ')
    end

    def setup_columns
      @columns = aggregate_columns.map do |e|
        Column.new(
          column_expr: "#{table_name}.#{e.column_name}",
          column_name: e.column_name,
          join_on: e.join_on,
          table_name: table_name
        )
      end.uniq(&:column_name)
    end
  end
end
