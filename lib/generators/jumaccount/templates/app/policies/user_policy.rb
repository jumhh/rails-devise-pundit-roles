# <%= generator_label_rb %>
class UserPolicy < ApplicationPolicy

  def index?
    @current_user.admin? 
  end

  def show?
    @current_user.admin? or @current_user == @model
  end

  def update?
    @current_user.admin?
  end

  def destroy?
    return false if @current_user == @model
    @current_user.admin?
  end

end
