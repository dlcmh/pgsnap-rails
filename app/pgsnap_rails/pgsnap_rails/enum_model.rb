# frozen_string_literal: true

module PgsnapRails
  class EnumModel
    # Generates a 2-column PG `VALUES` table of enum values to join against
    # and select values from
    Column = Struct.new(
      :column_expr,
      :column_name,
      :join_on,
      :type,
      keyword_init: true
    )

    Join = Struct.new(:column_expr, :column_name, keyword_init: true)

    attr_reader :columns, :model, :enum_column

    def initialize(model, enum_column)
      @enum_column = enum_column.to_s
      @model = model
      setup_columns
    end

    def column_names
      columns.pluck(:column_name)
    end

    def join_on(candidate_column_names)
      candidates = Array(candidate_column_names).map(&:to_s)
      joins = joinable_columns.select { |e| candidates.include?(e.join_on) }

      raise(ArgumentError, 'More than 1 join found') if joins.size > 1

      Join.new(joins.first.to_h.slice(:column_expr, :column_name)) if joins.present?
    end

    def joinable_columns
      columns.select { |e| e.type.in? %i[fk pk] }
    end

    def subquery_expr
      %[(SELECT * FROM (VALUES #{values}) t (#{column_names.join(', ')})) #{table_name}]
    end

    def table_name
      "#{model_name__downcased}_#{enum_column__pluralized}"
    end

    private

    def enum_column__pluralized
      enum_column.pluralize
    end

    def model_enum_column_name
      "#{model_name__downcased}_#{enum_column}"
    end

    def model_name__downcased
      model.name.downcase
    end

    def setup_columns
      @columns = [
        Column.new(
          column_expr: "#{table_name}.#{model_enum_column_name}",
          column_name: model_enum_column_name,
          join_on: model_enum_column_name,
          type: :pk
        ),
        Column.new(
          column_expr: "#{table_name}.#{value_column_name}",
          column_name: value_column_name
        )
      ]
    end

    def table_columns
      "#{model_enum_column_name}, #{value_column_name}"
    end

    def value_column_name
      "#{model_enum_column_name}_value"
    end

    def values
      model.send(enum_column__pluralized).invert.map do |key, value|
        "(#{key}, '#{value}')"
      end.join(', ')
    end
  end
end
