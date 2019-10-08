require 'dry/transaction/operation'

class Reports::DatesCalculator
  include Dry::Transaction::Operation
=begin

 getStartDate (start_date, end_date, period) {
   *const end_date_converted = new Date(end_date)
   *const start_date_converted = new Date(start_date)
   *let transform_date = new Date(start_date_converted)
   let new_date = 0
   let result = this.extract_new_date(transform_date, end_date_converted, period, new_date)

   return result
 },

 extract_new_date (transform_date, end_date, period, new_date) {
   if (transform_date > end_date) {
     return new_date;
   } else {
     new_date = new Date(transform_date)
     transform_date = new Date(transform_date.setMonth(transform_date.getMonth() + parseInt(period)))
     return this.extract_new_date(transform_date, end_date, period, new_date);
   }
 },
=end


  def call(input)
    location = input[:thing].location
    frequency = location.schedule_billing.billing_frequency
    new_date = 0
    result = extract_new_date(location.start_date, Time.now, frequency)

  end

  private

  def get_start_date(location)
  end

end
