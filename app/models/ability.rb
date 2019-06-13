class Ability
  include CanCan::Ability

  def initialize(user)
    user = user.success
    # can :read, :all # permissions for every user, even if not logged in
    if user.present?  # additional permissions for logged in users (they can manage their posts)
      p "osea, lol"
      p user
      if user.admin?  # additional permissions for administrators
        p "soy admin pero no puedo hacer un c***"
      end
      if user.support_workers.name = "AcueductoBogota"
        p user.support_workers.name
        p "FUCKING SERIOUS"
        can :manage, Thing
      end
    end
  end
end
