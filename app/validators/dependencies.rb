module Validators
  Dependencies = {
    create: {
      user:       Validators::Users::CreateSchema,
      downlink:   Validators::Downlinks::CreateSchema,
    },
  }
end
