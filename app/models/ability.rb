class Ability
  include CanCan::Ability

  RELATIONS = [:owns, :operates, :sees, :locates]

  def initialize(user)
    user = user.success

    available_relations = RELATIONS.select do |relation|
      user.send(relation).present?
    end

    if available_relations.any?
      available_relations.each {|relation| send("#{relation}_abilities", user) }
    else
      new_user_abilites(user)
    end
  end

  def locates_abilities(user)
    can :manage, Location, thing: { owner: { id: user.id } }
  end

  def owns_abilities(user)
    can :manage, Thing, owner: { id: user.id }
    can :manage, BatteryLevel, uplink: { thing: { owner: { id: user.id } } }
    can :manage, Alarm, uplink: { thing: { owner: { id: user.id } } }
    can :manage, Accumulator, uplink: { thing: { owner: { id: user.id } } }
    can :manage, Location
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
    can :read, Location, users: { id: user.id }
    can :create, Location
  end
end
