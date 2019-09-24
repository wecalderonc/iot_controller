module Validators
  Dependencies = {
    create: {
      user:                               Validators::Users::CreateSchema,
      location:                           Validators::Locations::CreateSchema,
      thing:                              Validators::Things::CreateSchema
    },

    update_state: {
      shadow:                             Validators::Shadows::UpdateShadowSchema,
      scheduled_cut:                      Validators::Downlinks::ScheduledSchema,
      restore_supply:                     Validators::Downlinks::InstantSchema,
      instant_cut:                        Validators::Downlinks::InstantSchema,
      restore_supply_with_scheduled_cut:  Validators::Downlinks::ScheduledSchema,
      reported:                           Validators::Downlinks::ReportedSchema,
      alarm:                              Validators::Alarms::UpdateSchema
    },

    get_price: {
      thing:                              Validators::Things::GetPricesSchema
    },

    update: {
      thing:                              Validators::Things::UpdateSchema,
      user:                               Validators::Users::UpdateSchema
    },

    recover_password: {
      user:                               Validators::Users::RecoverPasswordSchema
    },

    get: {
      battery_level:                      Validators::BatteryLevels::GetSchema,
      alarm:                              Validators::Alarms::GetSchema,
      accumulator:                        Validators::Accumulators::GetSchema,
      state:                              Validators::States::GetSchema,
      city:                               Validators::Cities::GetSchema
    },

    authenticate: {
      user:                               Validators::Users::AuthenticateSchema
    }
  }
end
