# frozen_string_literal: true

module PgsnapRails
  Ast = Struct.new(:aggregate_columns, :column_names, :columns, :compiled,
                   :distinct, :from, :filter, :group_by, :joins, :limit,
                   :pgsnap_instance, :selects, :sets, :sort, :table_name,
                   :the_right_model_tm, :top_level_column_names, :where,
                   :where_and) do
    def initialize
      self.aggregate_columns = AggregateColumns.new(self)
      self.column_names = ColumnNames.new(self)
      self.columns = Columns.new(self)
      self.distinct = Distinct.new
      self.filter = Where.new
      self.group_by = GroupBy.new(self)
      self.joins = Joins.new(self)
      self.limit = Limit.new
      self.selects = Selects.new(self)
      self.sets = Sets.new(self)
      self.sort = Sort.new
      self.the_right_model_tm = TheRightModelTm.new(self)
      self.top_level_column_names = TopLevelColumnNames.new(self)
      self.where = Where.new
      self.where_and = WhereAnd.new(self)
    end

    def abbreviated_table_name
      table_name.split('_').map(&:first).join
    end

    def compilation_done
      self.compiled = true
    end

    def model_for(obj)
      the_right_model_tm.for(obj)
    end

    def most_recent_from_or_join__columns
      [from, joins].flatten.compact.last.columns
    end

    def set(attr, value)
      self[attr] = value
      self
    end

    def tables
      [from, joins].flatten
    end
  end
end
