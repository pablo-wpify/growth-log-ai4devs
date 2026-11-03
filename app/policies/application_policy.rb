# Política base (GL-03, P-5): deniega todo. Cada política del producto
# permite de forma explícita solo lo que su regla admite.
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # Alcance base: vacío. Cada alcance del producto define su regla.
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.none
    end

    private
      attr_reader :user, :scope
  end
end
