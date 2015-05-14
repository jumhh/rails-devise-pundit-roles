<%= generator_label_rb %>
class <%= model_name %>Policy < ApplicationPolicy
  
  # Introduction
  
  # I decided to define admissions in ApplicationPolicy and 
  # the roles here in the <%= model_name %>Policy.
  # You can also put Scope and the resolve*-methods into ApplicationPolicy
  # and overwrite them here in special cases.
  #  
  # Base are these roles (see right.rb) and these granted rights
  #
  # enum right_role: {no_rights:  0, # => Cannot view or change anything
  #                   employee:   1, # => Needs full match of rights to admission to
  #                                  # => view or change anything. May create.
  #                   external:   2, # => same as employee
  #                   manager:    3, # => Can view everything. Cannot change or create
  #                   team_coach: 4, # => Needs team match of rights to admission to
  #                                  # => view anything. Cannot change or create
  #                   team_master: 5 # => same as team_coach
  #                  }


  # Scope for controller action index

  class Scope < Scope    
    def resolve
      if @current_right.employee? || @current_right.external?
        then full_admission_scope
      elsif @current_right.team_coach? || @current_right.team_master?
        then team_admission_scope
      elsif @current_right.manager?
        then scope.all
      else
        []
      end
    end
  end # Scope < Scope


  # Policy abstractions

  def resolve_admission_visible?
    if @current_right.employee? || @current_right.external?
      then full_admission?
    elsif @current_right.team_coach? || @current_right.team_master?
      then team_admission?
    elsif @current_right.manager?
      then true
    else
      false
    end
  end 

  def resolve_admission_change?
    if @current_right.employee? || @current_right.external?
      then full_admission?
    else
      false
    end
  end 

  def resolve_admission_create?
    @current_right.employee? || @current_right.external?
  end 


  # Policies according to controller actions

  def index?
    # @current_user.admin?
  end

  def show?
    resolve_admission_visible?
  end

  def new?
    resolve_admission_create?
  end

  def edit?
    resolve_admission_change?
  end

  def create?
    resolve_admission_create?
  end

  def update?
    resolve_admission_change?
  end

  def destroy?
    resolve_admission_change?
  end

end
