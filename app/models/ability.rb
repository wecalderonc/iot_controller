class Ability
  include CanCan::Ability

  def initialize(user)
    user = user.success
    #send("#{user.role}_abilities", user)
    citizen = "citizen"
    send("#{citizen}_abilities", user)
  end

  def admin_abilities(user)
    can :manage, :all
  end

  def citizen_abilities(user)
    can :manage, Thing, operator: { id: user.id }
  end

end
