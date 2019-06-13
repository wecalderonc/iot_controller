module Common
  class Container
    extend Dry::Container::Mixin

    register("validator")    { -> input { Dry::Monads::Result::Success.new(input) } }
    register("build_params") { -> input { input } }
    register("persist")      { -> input { Dry::Monads::Result::Success.new(input) } }

    Import = Dry::AutoInject self
  end
end
