# frozen_string_literal: true

module PgsnapRails
  class Joins < Array
    def initialize(ast)
      @ast = ast
    end

    def assign(method, model, opts = {})
      method = method.to_s
      model = if IsActiveRecord.model?(model)
                ArModel.new(model, opts[:enum], opts[:only])
              else
                @ast.model_for(model)
              end
      self << the_join(method, model, opts)
    end

    private

    def the_join(method, model, opts)
      Join.new(@ast, method, model, opts)
    end
  end
end
