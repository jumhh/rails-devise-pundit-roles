# config/initializers/pundit.rb
# Extends the ApplicationController to add Pundit for authorization.
# Modify this file to change the behavior of a 'not authorized' error.
# Be sure to restart your server when you modify this file.
module PunditHelper
  extend ActiveSupport::Concern

  included do
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

  private

  def user_not_authorized
    flash[:alert] = "Access denied."
    redirect_to (request.referrer || root_path)
  end

end

# Generated by jumaccount_generator 1.0.0 Start
# unless-Condition for better development. See also application_controller.rb
# https://github.com/RailsApps/rails-devise-pundit/issues/10
# https://gist.github.com/vjm/e7d9dbb7603553bfbd2a

# ApplicationController.send :include, PunditHelper
ApplicationController.send :include, PunditHelper unless Rails.env.development?
# Generated by jumaccount_generator 1.0.0 End

