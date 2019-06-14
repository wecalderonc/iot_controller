class Ability
  include CanCan::Ability

  def initialize(user)
    user = user.success
    # can :read, :all # permissions for every user, even if not logged in
    if user.present?  # additional permissions for logged in users (they can manage their posts)
      if user.support_workers.name = "AcueductoBogota"
        can :read, Thing
        if user.admin?  # additional permissions for administrators
          can :manage, Thing
        end
      end
    end
  end
end
