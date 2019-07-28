# frozen_string_literal: true

module PgsnapRails
  module PgsnapDelegations
    delegate :c_count, :c_max, :c_sum,
             to: :aggregates

    delegate :table_name,
             to: :ast

    delegate :calc, :c_div, :c_minus,
             to: :calculations

    delegate :compile,
             to: :compiler

    delegate :_eq, :_gt, :_ne, :_is_false, :_is_not_null, :_is_null, :_is_true,
              to: Operators

    delegate :aggregate_column, :column, :distinct, :from, :join,
             :left_join, :select_all_columns, :where, :where_and,
             to: :parser

    delegate :filter, :limit, :sort,
             to: :post_compilation_parser

    delegate :union,
             to: :set_operations

    delegate :pretty, :to_sql,
             to: :sql

    delegate :all,
             to: :sql_runner
  end
end
