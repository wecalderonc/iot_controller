module Common

  TxBuilder = -> steps, container do
    Class.new do
      include Dry::Transaction(container: container)

      steps.each do |step|
        if step[:adapter].eql?(:try)
          send step[:adapter], step[:name], catch: step[:catch], with: "ops.#{step[:name]}"
        else
          send step[:adapter], step[:name], with: "ops.#{step[:name]}"
        end
      end
    end
  end

  class TxMasterBuilder
    def initialize(&block)
      @steps = []
      instance_eval(&block)
    end

    def Do
      _steps = @steps
      container = Class.new(Common::Container) do
        _steps.each do |step|
          register("ops.#{step[:name]}", step[:with])
        end
      end

      trx = TxBuilder.(_steps, container)
      [container, trx]
    end

    def method_missing(method, *args, &block)
      if [:step, :map, :tee, :try].include?(method)
        options = args.last
        @steps << {
          adapter: method,
          name: args.first,
          catch: options[:catch],
          with: options[:with]
        }
      else
        super
      end
    end

    def try(name, args)
      new_args = [name, args]
      method_missing(:try, *new_args)
    end
  end
end
