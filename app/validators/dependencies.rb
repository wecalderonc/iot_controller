module Validators
  Dependencies = {
    create: {
      user:       Validators::Users::CreateSchema,
    },

    update_state: {
      shadow:                             Validators::Shadows::UpdateShadowSchema,
      scheduled_cut:                      Validators::Downlinks::ScheduledSchema,
      restore_supply:                     Validators::Downlinks::InstantSchema,
      instant_cut:                        Validators::Downlinks::InstantSchema,
      restore_supply_with_scheduled_cut:  Validators::Downlinks::ScheduledSchema,
      reported:                           Validators::Downlinks::ReportedSchema
    },

    get_price: {
      thing:        Validators::Things::GetPricesSchema
    }
  }
end
