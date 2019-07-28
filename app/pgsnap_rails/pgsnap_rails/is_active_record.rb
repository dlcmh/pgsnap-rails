# frozen_string_literal: true

module PgsnapRails
  class IsActiveRecord
    class << self
      def model?(obj)
        obj.respond_to?(:has_many) || obj.respond_to?(:transaction)
      end
    end
  end
end
