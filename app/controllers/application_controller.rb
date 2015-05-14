class ApplicationController < ActionController::Base
  # Generated by jumaccount_generator 1.0.0 Start
  # https://github.com/RailsApps/rails-devise-pundit/issues/10
  # https://gist.github.com/vjm/e7d9dbb7603553bfbd2a
  # Fuer bessere Entwicklung mit pundit. See pundit.rb
  include Pundit
  include CurrentAuthority
  helper ApplicationHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Pundit additional "context", here current_user + current_right
  def pundit_user
    CurrentAuthority.new(current_user, current_right)
  end

  def current_right
    Right.new(session[:current_right])
  end
  # Generated by jumaccount_generator 1.0.0 End

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Generated by jumaccount_generator 1.0.0 Start
  # Fuer bessere Entwicklung mit pundit. Siehe oben. See pundit.rb
  private
  def user_not_authorized
    flash[:alert] = "Access denied." # TODO: make sure this isn't hard coded English.
    if (request.referrer == request.url)
      redirect_to root_path
    else
      redirect_to (request.referrer || root_path) # Send them back to them page they came from, or to the root page.
    end
  end
  # Generated by jumaccount_generator 1.0.0 End

end
