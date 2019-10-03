require 'dry/transaction/operation'

class Reports::BaseJsonReport
  include Dry::Transaction::Operation

  def call(input)
    objects, model = input.values_at(:objects, :model)

    objects.each_with_object([]) do |(device, objects), response|
      deltas = get_deltas(objects, model)

      processed_objects = []

      objects.each_with_index do |object, index|
        hash = add_basic_object_info(object)

        if model.eql?(:accumulator)
          add_deltas(deltas, index, hash)
        end

        processed_objects << hash
      end

      response << add_device_info(device, processed_objects, model)
    end
  end

  private

  def get_deltas(objects, model)
    AccumulatorDeltaBuilder.new.(objects) if model.eql?(:accumulator)
  end

  def add_basic_object_info(object)
    date = Utils.parse_date(object.uplink.created_at)

    { :date => date, :value => object.value }
  end

  def add_deltas(deltas, index, hash)
    hash.merge!({
      :consumption_delta => deltas[index][:delta],
      :accumulated_delta => deltas[index][:accumulated]
    })
  end

  def add_device_info(device, processed_objects, model)
    key_objects = "#{model.to_s}s".to_sym # This key can be alarms or accumulators

    { :thing_id => device.id, :thing_name => device.name, key_objects => processed_objects }
  end
end
