# <%= generator_label_rb %>
class ProfilePolicy < ApplicationPolicy

  def index?
    @current_user.admin?
  end

  def show?
    @current_user.admin? or @current_user.id == @model.user_id
  end

  def new?
    @current_user.admin?
  end
  
  def edit?
    @current_user.admin?
  end

  def create?
    @current_user.admin? or @current_user.id == @model.user_id
  end

  def update?
    @current_user.admin? or @current_user.id == @model.user_id
  end
  
  def useredit?
    return true
  end
  def quit?
    return true
  end

  def destroy?
    @current_user.admin?
  end

end
