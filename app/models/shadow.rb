class Shadow
  VALID_ACTIONS = [:scheduled_cut, :restore_supply, :instant_cut, :restore_supply_with_scheduled_cut]
  VALID_INPUT_TYPES = [:consumption, :accumulated_value]
  VALID_UPDATE_TYPES = [:desired, :reported]
end
