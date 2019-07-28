# frozen_string_literal: true

module PgsnapRails
  class AssignFrom
    def initialize(ast, model, opts = {})
      @ast = ast
      @enum = opts[:enum]
      @model = model
      @only_columns = opts[:only]
    end

    def assign
      assignment__if_ar_model || assignment__default
    end

    private

    def assignment__if_ar_model
      return unless IsActiveRecord.model?(@model)

      obj = ArModel.new(@model, @enum, @only_columns)
      From.new(
        obj.top_level_columns.map do |col|
          Column.new(@ast, col).assign
        end,
        obj.to_sql,
        obj.table_name
      ).tap do |value|
        @ast.set(:from, value)
      end
    end

    def assignment__default
      m = @ast.model_for(@model)

      From.new(
        m.top_level_columns.map do |col|
          Column.new(@ast, col).assign
        end,
        m.to_sql,
        m.table_name
      ).tap do |value|
        @ast.set(:from, value)
      end
    end
  end
end
