# frozen_string_literal: true

class Months < Pgsnap
  main do
    from "GENERATE_SERIES(NOW() - INTERVAL '1 YEAR', NOW(), '1 MONTH')", :series
    column "TO_CHAR(series, 'yyyy')", :year
    column "TO_CHAR(series, 'mm')", :month
    column "DATE_TRUNC('month', series)", :first_day_of_month
  end

  variant :descending, lambda {
    order :first_day_of_month, :desc
  }
end
