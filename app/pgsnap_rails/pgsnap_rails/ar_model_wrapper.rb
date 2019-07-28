# frozen_string_literal: true

module PgsnapRails
  class ArModelWrapper
    # HIDE_THESE_COLUMN_NAMES = %w[
    #   created_at
    #   updated_at
    # ].freeze

    Column = Struct.new(
      :base_column_name,
      :column_expr,
      :column_name,
      :join_on,
      :type,
      keyword_init: true
    )

    Join = Struct.new(:column_expr, :column_name, keyword_init: true)

    attr_reader :columns, :enums, :model

    def initialize(model, enums = [], only_columns = nil)
      @enums = Array(enums)
      @model = model
      @only_columns = Array(only_columns).map(&:to_s) if only_columns
      setup_columns
    end

    def join_on(candidate_column_names)
      candidates = Array(candidate_column_names).map(&:to_s)
      joins = joinable_columns.select { |e| candidates.include?(e.join_on) }

      raise(ArgumentError, 'More than 1 join found') if joins.size > 1

      Join.new(joins.first.to_h.slice(:column_expr, :column_name)) if joins.present?
    end

    def joinable_columns
      columns.select { |e| e.type.in? %i[enum fk pk] }
    end

    def subquery_expr
      "(#{to_sql}) t"
    end

    def table_name
      model.table_name
    end

    def to_sql
      [
        'SELECT',
        columns.map do |e|
          if e.base_column_name == e.column_name
            e.column_name
          else
            "#{e.base_column_name} #{e.column_name}"
          end
        end.join(', '),
        'fRoM',
        table_name
      ].join(' ')
    end

    private

    def belongs_to_associations
      model.reflect_on_all_associations.filter do |e|
        e.is_a?(ActiveRecord::Reflection::BelongsToReflection)
      end
    end

    def enum_columns
      enums.map do |e|
        column_name = e.to_s
        model_column_name = "#{model_name.downcase}_#{column_name}"
        Column.new(
          base_column_name: column_name,
          column_expr: "t.#{model_column_name}",
          column_name: model_column_name.to_s,
          join_on: model_column_name.to_s,
          type: :enum
        )
      end
    end

    def foreign_key_columns
      belongs_to_associations.map do |e|
        parent_class_name = e.options[:class_name]
        base_column_name = "#{e.name}_id"
        Column.new(
          base_column_name: base_column_name,
          column_expr: "t.#{base_column_name}",
          column_name: base_column_name,
          join_on: if parent_class_name
                     "#{parent_class_name.to_s.downcase}_id"
                   else
                     base_column_name
                   end,
          type: :fk
        )
      end
    end

    def model_name
      model.name
    end

    def primary_key
      model.primary_key
    end

    def primary_key_column
      name = "#{model_class_name__downcased}_#{primary_key}"
      Column.new(
        base_column_name: primary_key,
        column_expr: "t.#{name}",
        column_name: name.to_s,
        join_on: name.to_s,
        type: :pk
      )
    end

    def append__rest_of_the_columns
      @columns.concat [*(
        model.column_names \
        - joinable_columns.pluck(:base_column_name) \
        # - HIDE_THESE_COLUMN_NAMES
      ).map do |e|
        name = if e.starts_with?(model_class_name__downcased)
                 e
               else
                 "#{model_class_name__downcased}_#{e}"
               end
        Column.new(
          base_column_name: e,
          column_expr: "t.#{name}",
          column_name: name
        )
      end]
    end

    def select__only_columns
      return unless @only_columns.present?
      columns.select! { |col| col.base_column_name.in?(@only_columns) }
    end

    def setup_columns
      @columns = [
        primary_key_column,
        *foreign_key_columns,
        *enum_columns
      ]
      append__rest_of_the_columns
      select__only_columns
    end

    def model_class_name__downcased
      @model_class_name__downcased ||= model.name.downcase
    end
  end
end
