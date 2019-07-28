# frozen_string_literal: true

module PgsnapRails
  class Operators
    class << self
      def _eq
        '='
      end

      def _gt
        '>'
      end

      def _ne
        '!='
      end

      def _is_false
        'IS FALSE'
      end

      def _is_not_null
        'IS NOT NULL'
      end

      def _is_null
        'IS NULL'
      end

      def _is_true
        'IS TRUE'
      end
    end
  end
end
