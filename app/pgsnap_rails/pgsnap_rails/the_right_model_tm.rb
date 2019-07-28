# frozen_string_literal: true

module PgsnapRails
  class TheRightModelTm
    def initialize(ast)
      @ast = ast
      @obj = nil
    end

    def for(obj)
      @obj = obj
      pgsnap_subclass__instantiated \
      || pgsnap_subclass__already_instantiated \
      || symbol__main_query_of_pgsnap_instance \
      || symbol__scoped_query_of_pgsnap_instance
    end

    private

    def obj_as_sym
      @obj.to_sym if obj_string_or_symbol?
    end

    def obj_string_or_symbol?
      @obj.is_a?(String) || @obj.is_a?(Symbol)
    end

    def pgsnap_instance
      @ast.pgsnap_instance
    end

    def pgsnap_subclass__instantiated
      @obj.new.main_built if @obj.try(:klass) == 'pgsnap'
    end

    def pgsnap_subclass__already_instantiated
      @obj if @obj.try(:klass) == 'pgsnap_instance'
    end

    def sym_main?
      obj_as_sym == :main
    end

    def sym_scope?
      true if obj_as_sym && !sym_main?
    end

    def symbol__main_query_of_pgsnap_instance
      pgsnap_instance.class.new.main_built if sym_main?
    end

    def symbol__scoped_query_of_pgsnap_instance
      pgsnap_instance.class.send(obj_as_sym)
    end
  end
end
