class Ability
  include CanCan::Ability

  RELATIONS = [:owns, :operates, :sees]

  def initialize(user)
    user = user.success

    available_relations = RELATIONS.select do |relation|
      user.send(relation).present?
    end

    available_relations.each {|relation| send("#{relation}_abilities", user) }
  end

  def administrates_abilities(user)
    can :manage, :all
  end

  def owns_abilities(user)
    can :manage, Thing, owner: { id: user.id }
    can :manage, BatteryLevel, uplink: { thing: { owner: { id: user.id } } }
  end

  def sees_abilities(user)
    can :read, Thing, viewer: { id: user.id }
    can :read, BatteryLevel, uplink: { thing: { viewer: { id: user.id } } }
  end

  def operates_abilities(user)
    can :read, Thing, operator: { id: user.id }
  end

end
