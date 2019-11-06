class Ability
  include CanCan::Ability

  RELATIONS = [:owns, :operates, :sees, :user_location]

  def initialize(user)
    user = user.success

    p available_relations = RELATIONS.select do |relation|
      user.send(relation).present?
    end

    p available_relations

    if available_relations.any?
      available_relations.each {|relation| send("#{relation}_abilities", user) }
    else
      new_user_abilites(user)
    end
  end

  def user_location_abilities(user)
    can :manage, Location, thing: { owner: { id: user.id } }
  end

  def owns_abilities(user)
    can :manage, Thing, owner: { id: user.id }
    can :manage, BatteryLevel, uplink: { thing: { owner: { id: user.id } } }
    can :manage, Alarm, uplink: { thing: { owner: { id: user.id } } }
    can :manage, Accumulator, uplink: { thing: { owner: { id: user.id } } }
    can :manage, Location, users: { id: user.id }
  end

  def sees_abilities(user)
    can :read, Thing, viewer: { id: user.id }
    can :read, BatteryLevel, uplink: { thing: { viewer: { id: user.id } } }
    can :read, Alarm, uplink: { thing: { owner: { id: user.id } } }
    can :read, Location, thing: { owner: { id: user.id } }
  end

  def operates_abilities(user)
    can :read, Thing, operator: { id: user.id }
    can :read, Location, thing: { owner: { id: user.id } }
  end

  def new_user_abilites(user)
    can :create, Location
  end
end
