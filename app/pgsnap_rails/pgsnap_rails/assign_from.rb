# frozen_string_literal: true

module PgsnapRails
  class AssignFrom
    def initialize(ast, model, opts = {})
      @ast = ast
      @enum = opts[:enum]
      @model = model
      @only_columns = Array(opts[:only]).map(&:to_s)
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
      top_level_columns = if @only_columns.presence
                            m.top_level_columns.select do |rec|
                              rec.column_name.in?(@only_columns)
                            end
                          else
                            m.top_level_columns
                          end

      From.new(
        top_level_columns.map do |col|
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
