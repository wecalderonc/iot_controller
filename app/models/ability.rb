class Ability
  include CanCan::Ability

  def initialize(user)
    user = user.success
    # can :read, :all # permissions for every user, even if not logged in
    can :manage, :all
    if user.present?  # additional permissions for logged in users (they can manage their posts)
      can :manage, Thing
    end
  end
end
