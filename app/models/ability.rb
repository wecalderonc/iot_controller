class Ability
  include CanCan::Ability

  def initialize(user)
    user = user.success
    can :manage, :all
  end

end
