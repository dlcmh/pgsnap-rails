# frozen_string_literal: true

module PgsnapRails
  module PgsnapClassMethods
    def all; new.main_built.all; end
    def to_sql; new.main_built.to_sql; end

    def klass
      'pgsnap'
    end

    def scope(name, &code)
      singleton_class.send(:define_method, name) do |*args|
        new.send(name, *args)
      end
      define_method(name) do |*args|
        ast.pgsnap_instance = self
        ast.table_name = "#{class_name_underscored}_#{name}"
        instance_exec(*args, &code)
        compile
        self
      end
    end

    def view(name, &code)
      singleton_class.send(:define_method, name) do |*args|
        if args.present?
          raise(ArgumentError, "View `:#{name}` cannot have arguments")
        end
        new.send(name)
      end
      define_method(name) do |*args|
        ast.pgsnap_instance = self
        ast.table_name = "#{class_name_underscored}_#{name}"
        instance_exec(&code)
        compile
        self
      end
    end

    def main(&blk)
      define_method('main', &blk)
    end
  end
end
