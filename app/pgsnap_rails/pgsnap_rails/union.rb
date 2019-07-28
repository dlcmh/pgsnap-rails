# frozen_string_literal: true

module PgsnapRails
  Union = Struct.new(:model) do
    def initialize(model)
      self.model = model
    end

    def clause
      ['UNION', "(#{model.to_sql})"].join(' ')
    end
  end
end
