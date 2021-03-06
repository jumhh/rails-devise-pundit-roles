# # Generated by jumaccount_generator 1.0.0
class RightPolicy < ApplicationPolicy

  def index?
    @current_user.admin?
  end

  def userindex?
    @current_user.admin?
  end

  def show?
    @current_user.admin? or user_admission?
  end

  def update?
    @current_user.admin?
  end

  def edit?
    @current_user.admin?
  end

  def useredit?
    @current_user.admin?
  end

  def userchoose?
     user_admission?
  end

  def usercreate?
    @current_user.admin?
  end

  def create?
    @current_user.admin?
  end

  def destroy?
    @current_user.admin?
  end

end
