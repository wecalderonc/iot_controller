module Validators
  Dependencies = {
    create: {
      user:       Validators::Users::CreateSchema,
      downlink:   Validators::Downlinks::CreateSchema,
    },

    update_state: {
      scheduled_cut:            Validators::Downlinks::ScheduledSchema,
      restore_supply:           Validators::Downlinks::InstantSchema,
      instant_cut:              Validators::Downlinks::InstantSchema,
      scheduled_restore_supply: Validators::Downlinks::ScheduledSchema,
      reported:                 Validators::Downlinks::ReportedSchema
    }
  }
end
