class Ability
  include CanCan::Ability

  ARRAY = [:owns, :operates, :sees]

  def initialize(user)
    user = user.success

    guardar = ARRAY.select do |x|
      user.send(x).present?
      #
    end
    p "!!!!!!!!!!!!!!!!!!!1"
    p guardar
    p "!!!!!!!!!!!!!!!!!!!1"
    guardar.each {|x| send("#{x}_abilities", user) }
  end

  def administrator_abilities(user)
    can :manage, :all
  end

  def owns_abilities(user)
    can :manage, Thing, owner: { id: user.id }
  end

  def sees_abilities(user)
    can :read, Thing, viewer: { id: user.id }
  end

  def operates_abilities(user)
    can :read, Thing, operator: { id: user.id }
  end

end
