# frozen_string_literal: true

module PgsnapRails
  class Sets < Array
    def initialize(ast)
      @ast = ast
      @method = nil
    end

    def assign(method, model)
      @method = method.to_s
      model = if IsActiveRecord.model?(model)
                ArModel.new(model, opts[:enum], opts[:only])
              else
                @ast.model_for(model)
              end
      self << the_set(model)
    end

    def clause
      map do |directive|
        directive.clause
      end.join(' ')
    end

    private

    def the_set(model)
      case @method
      when 'union'
        Union.new(model)
      end
    end
  end
end
