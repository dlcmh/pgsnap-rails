module PgsnapRails
  class JoinType
    # left_join -> LEFT JOIN
    def self.from(method)
      method.split('_').map(&:upcase).join(' ')
    end
  end
end
