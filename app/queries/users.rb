# frozen_string_literal: true

class Users < Pgsnap
  main do
    from User, only: %i[id email user_type]
  end
end
