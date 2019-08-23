class ScheduleBillingSerializer < ActiveModel::Serializer
  attributes  :stratum,
              :basic_charge,
              :top_limit,
              :basic_price,
              :extra_price,
              :billing_frequency,
              :billing_period,
              :cut_day,
              :start_date
end
