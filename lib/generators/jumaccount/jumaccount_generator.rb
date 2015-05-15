# encoding: utf-8

class JumaccountGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :application_name_in, :type => :string
  
  @@gen_version = "1.0.0"

  def generate_jumaccount 

    #
    # configs
    #
    puts "--configs--"

    insert_into_file "config/environments/development.rb",
                     :after => "  config.assets.debug = true\n" do
      "\n  config.action_mailer.smtp_settings = {\n" +
      "    address: \"smtp.gmail.com\",\n" +
      "    port: 587,\n" +
      "    domain: Rails.application.secrets.domain_name,\n" +
      "    authentication: \"plain\",\n" +
      "    enable_starttls_auto: true,\n" +
      "    user_name: Rails.application.secrets.email_provider_username,\n" +
      "    password: Rails.application.secrets.email_provider_password\n" +
      "  }\n" +
      "  # ActionMailer Config\n" +
      "  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\n" +
      "  config.action_mailer.delivery_method = :smtp\n" +
      "  config.action_mailer.raise_delivery_errors = true\n" +
      "  # Send email in development mode?\n" +
      "  config.action_mailer.perform_deliveries = true\n\n"
    end
    
    insert_into_file "config/environments/production.rb",
                     :after => "config.active_support.deprecation = :notify\n" do
      "\n  config.action_mailer.smtp_settings = {\n" +
      "    address: \"smtp.gmail.com\",\n" +
      "    port: 587,\n" +
      "    domain: Rails.application.secrets.domain_name,\n" +
      "    authentication: \"plain\",\n" +
      "    enable_starttls_auto: true,\n" +
      "    user_name: Rails.application.secrets.email_provider_username,\n" +
      "    password: Rails.application.secrets.email_provider_password\n" +
      "  }\n" +
      "  # ActionMailer Config\n" +
      "  config.action_mailer.default_url_options = { :host => Rails.application.secrets.domain_name }\n" +
      "  config.action_mailer.delivery_method = :smtp\n" +
      "  config.action_mailer.raise_delivery_errors = false\n" +
      "  config.action_mailer.perform_deliveries = true\n\n"
    end

    insert_into_file "config/initializers/filter_parameter_logging.rb",
                     :after => "Rails.application.config.filter_parameters += [:password" do
      ", :password_confirmation"
    end
    insert_into_file "db/seeds.rb",
                     :after => "#   Mayor.create(name: 'Emanuel', city: cities.first)" do
      "\nuser = CreateAdminService.new.call\n" +
      "puts 'CREATED ADMIN USER: ' << user.email\n"
    end
  
    #
    # gems
    #
    puts "--Gems--"
    gem 'bootstrap-sass'
    gem 'devise'
    gem 'pundit'

    #
    # bundle
    #
    puts "--bundle--"
    run("bundle install") # vorübergehend..

    puts "--devise--"
    if ( ! File.file?("config/initializers/devise.rb") )
      #
      # devise technical
      #
      generate "devise:install"
      generate "devise:views"
      # additionally to rails-devise-pundit - solution the following files are generated:
      #  create    app/views/devise/unlocks
      #  create    app/views/devise/unlocks/new.html.erb
      #  invoke  erb
      #  create    app/views/devise/mailer
      #  create    app/views/devise/mailer/confirmation_instructions.html.erb
      #  create    app/views/devise/mailer/reset_password_instructions.html.erb
      #  create    app/views/devise/mailer/unlock_instructions.html.erb

      #
      # devise User
      #

      puts "--devise User--"
      generate "devise User"
      generate "migration" " AddSystemRoleToUser user_system_role:integer user_account_name:string"
      # SELECT  1 AS one FROM "users" WHERE "users"."email" = 'user@example.com' LIMIT 1
      # INSERT INTO "users" ("email", "encrypted_password", "role", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?) [0m  [["email", "user@example.com"], ["encrypted_password", "$2a$10$2uXsblmUwigN5v1oQctnsuKcX1mHz2YZw5q2g7zFq2ZMkC6P3Rv26"], ["role", 2], ["created_at", "2015-03-28 19:36:36.793272"], ["updated_at", "2015-03-28 19:36:36.793272"]]
      rake("db:migrate")
    end

    template "config/initializers/devise_permitted_parameters.rb"
    template "config/initializers/devise.rb"
    
    # This may lead to an error. So just do it by hand and start generator again:
    comment "config/initializers/devise.rb", "config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'"
    insert_into_file "config/initializers/devise.rb", 
                     :after => "# with default \"from\" parameter.\n" do
      "  config.mailer_sender = 'no-reply@' + Rails.application.secrets.domain_name\n"                     
    end
    
    copy_file "config/locales/devise.en.yml"
    copy_file "config/locales/devise.de.yml"

    insert_into_file "config/secrets.yml", 
                     :after => "development:\n" do
      "  #{generator_label_rb} Start\n" +
      "  admin_name: First User\n" +
      "  admin_email: user@example.com\n" +
      "  admin_password: changeme\n" +
      "  domain_name: example.com\n"
    end

    insert_into_file "config/secrets.yml", 
                     :after => "test:\n" do
      "  #{generator_label_rb} Start\n" +
      "  domain_name: example.com\n"
    end

    insert_into_file "config/secrets.yml", 
                     :after => "production:\n" do
      "  admin_name: <%= ENV[\"ADMIN_NAME\"] %>\n" +
      "  admin_email: <%= ENV[\"ADMIN_EMAIL\"] %>\n" +
      "  admin_password: <%= ENV[\"ADMIN_PASSWORD\"] %>\n" +
      "  domain_name: <%= ENV[\"DOMAIN_NAME\"] %>\n"
    end
    rake("db:seed")
    
    puts "--pundit--"
    template "config/initializers/pundit.rb"
 
#    puts "--Pundit--"
#    insert_into_file "config/initializers/pundit.rb", 
#                     :after => "ApplicationController.send :include, PunditHelper" do
#      " unless Rails.env.development?\n" +
#      "# {generator_label_rb}\n" +
#      "# unless-Condition for better development. See application_controller.rb\n" +
#      "# https://github.com/RailsApps/rails-devise-pundit/issues/10\n" +
#      "# https://gist.github.com/vjm/e7d9dbb7603553bfbd2a\n"                   
#    end
    insert_into_file "app/controllers/application_controller.rb", 
                     :after => "class ApplicationController < ActionController::Base\n" do
      "  #{generator_label_rb} Start\n" +
      "  # https://github.com/RailsApps/rails-devise-pundit/issues/10\n" +
      "  # https://gist.github.com/vjm/e7d9dbb7603553bfbd2a\n" +       
      "  # Fuer bessere Entwicklung mit pundit. See pundit.rb\n" +
      # "  if Rails.env.development?\n" +
      "  include Pundit\n" +
      "  include CurrentAuthority\n" +
      "  helper ApplicationHelper\n\n" +
      "  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized\n\n" +
      # "  end\n" +      
      "  # Pundit additional \"context\", here current_user + current_right\n" +
      "  def pundit_user\n" +
      "    CurrentAuthority.new(current_user, current_right)\n" +
      "  end\n\n" +
      "  def current_right\n" +
      "    Right.new(session[:current_right])\n" +
      "  end\n" + 
      "  #{generator_label_rb} End\n\n"
    end

    insert_into_file "app/controllers/application_controller.rb", 
                     :before => "\nend\n" do
      "\n\n  #{generator_label_rb} Start\n" +
      "  # Fuer bessere Entwicklung mit pundit. Siehe oben. See pundit.rb\n" +
      "  private\n" +
      #  if Rails.env.development?
      "  def user_not_authorized\n" +
      "    flash[:alert] = \"Access denied.\" # TODO: make sure this isn't hard coded English.\n" +
      "    if (request.referrer == request.url)\n" +
      "      redirect_to root_path\n" +
      "    else\n" +
      "      redirect_to (request.referrer || root_path) # Send them back to them page they came from, or to the root page.\n" +
      "    end\n" +
      "  end\n" +
      #  end
      "  #{generator_label_rb} End\n"
    end

    insert_into_file "app/helpers/application_helper.rb", 
                     :after => "module ApplicationHelper\n" do
      "  #{generator_label_rb} Start\n" +
      "  def current_right\n" +
      "    return session[:current_right]\n" +
      "  end\n" +
      "  #{generator_label_rb} End\n"
    end
    template "app/helpers/current_authority.rb"

    puts "--User views--"
    template "app/controllers/users_controller.rb"
    template "app/controllers/visitors_controller.rb"
    insert_into_file "app/models/user.rb", 
                     :after => "class User < ActiveRecord::Base\n" do
      "  #{generator_label_rb} Start\n" +
      "      enum user_system_role: [:user, :team_admin, :company_admin, :admin]\n" +
      "  after_initialize :set_default_user_system_role, :if => :new_record?\n" +
      "  has_many :rights\n" +
      "  has_one :profile\n\n" +  
      "  def set_default_user_system_role\n" +
      "    self.user_system_role ||= :user\n" +
      "  end\n" +
      "  #{generator_label_rb} End\n"
    end
    # template "app/models/user.rb"
    template "app/policies/user_policy.rb"
    template "app/services/create_admin_service.rb"
    
    template "app/views/devise/passwords/edit.html.erb"
    template "app/views/devise/passwords/new.html.erb"
    template "app/views/devise/registrations/edit.html.erb"
    template "app/views/devise/registrations/new.html.erb"
    template "app/views/devise/sessions/new.html.erb"
    
    template "app/views/layouts/_messages.html.erb"
    template "app/views/layouts/_navigation_accounting.html.erb"
    template "app/views/layouts/_navigation.html.erb"
    template "app/views/layouts/application.html.erb"

    template "app/views/users/_user.html.erb"
    template "app/views/users/index.html.erb"
    template "app/views/users/show.html.erb"

    template "app/views/visitors/index.html.erb"
        
    puts "--Company, Team, Right, Profile --"


    if ( ! File.file?("app/models/company.rb") )
      generate "scaffold" " Company company_name:string"
      rake("db:migrate")
    end
    if ( ! File.file?("app/models/team.rb") )
      generate "scaffold" " Team team_name:string"
      rake("db:migrate")
    end
    if ( ! File.file?("app/models/right.rb") )
      generate "scaffold" " Right right_role:integer user:references company:references team:references"
      rake("db:migrate")
    end
    if ( ! File.file?("app/models/profile.rb") )
      generate "scaffold" " Profile profile_first_name:string profile_last_name:string profile_preferred_right_id:integer user:references "
      rake("db:migrate")
    end

    puts 'Please answer yes'
    template "app/controllers/companies_controller.rb"
    template "app/controllers/profiles_controller.rb"
    template "app/controllers/rights_controller.rb"
    template "app/controllers/teams_controller.rb"
 
    template "app/helpers/current_authority.rb"
    template "app/helpers/profiles_helper.rb"
    template "app/helpers/rights_helper.rb"
    # teams_helper and companies_helper stay as scaffolded
    
    template "app/models/company.rb"
    template "app/models/profile.rb"
    template "app/models/right.rb"
    template "app/models/team.rb"
    
    template "app/policies/application_policy.rb"
    template "app/policies/company_policy.rb"
    template "app/policies/profile_policy.rb"
    template "app/policies/right_policy.rb"
    template "app/policies/team_policy.rb"

    template "app/views/companies/_form.html.erb"
    template "app/views/companies/edit.html.erb"
    template "app/views/companies/index.html.erb"
    template "app/views/companies/new.html.erb"
    template "app/views/companies/show.html.erb"
    # json-files not adapted
    
    template "app/views/profiles/_form.html.erb"
    template "app/views/profiles/edit.html.erb"
    template "app/views/profiles/index.html.erb"
    template "app/views/profiles/new.html.erb"
    template "app/views/profiles/show.html.erb"
    # json-files not adapted

    template "app/views/teams/_form.html.erb"
    template "app/views/teams/edit.html.erb"
    template "app/views/teams/index.html.erb"
    template "app/views/teams/new.html.erb"
    template "app/views/teams/show.html.erb"
    # json-files not adapted

    template "app/views/rights/_form_errors.html.erb"
    template "app/views/rights/_form_fields.html.erb"
    template "app/views/rights/_form.html.erb"
    template "app/views/rights/_right.html.erb"
    template "app/views/rights/_userform.html.erb"
    template "app/views/rights/edit.html.erb"
    template "app/views/rights/index.html.erb"
    template "app/views/rights/new.html.erb"
    template "app/views/rights/show.html.erb"
    template "app/views/rights/useredit.html.erb"
    template "app/views/rights/userindex.html.erb"
    template "app/views/rights/usernew.html.erb"
    template "app/views/rights/usershow.html.erb"
    # json-files not adapted
    
    # If you have a duplicate route e.g. "root" you cannot call rails and have to
    # clear the problem by hand
    
    insert_into_file "config/routes.rb",
                     :after => "Rails.application.routes.draw do\n" do
      "\n  #{generator_label_rb} Start (vor resources :profiles!)\n" +
      "  get 'users/profiles/edit'   => 'profiles#useredit', :as => 'edit_user_profile'\n" +
      "  get 'users/profiles/quit'   => 'profiles#quit', :as => 'quit_user_profile'\n\n" +
  
      "  get   'users/:user_id/rights' => 'rights#userindex',  :as => 'user_rights'\n" +
      "  post  'users/:user_id/rights' => 'rights#usercreate',  :as => 'create_user_right'\n" +
      "  get   'users/:user_id/rights/new' => 'rights#usernew',  :as => 'new_user_right'\n" +
      "  get   'users/:user_id/rights/:id/edit' => 'rights#useredit',  :as => 'edit_user_right'\n" +
      "  get   'users/:user_id/rights/:id' => 'rights#usershow',  :as => 'user_right'\n" +
      "  patch 'users/:user_id/rights/:id' => 'rights#userupdate'\n" +
      "  put   'users/:user_id/rights/:id' => 'rights#userupdate'\n" +
      "  delete 'users/:user_id/rights/:id' => 'rights#userdestroy'\n" +
      "  get   'users/:user_id/rights/:id/choose' => 'rights#userchoose',  :as => 'choose_user_right'\n\n" +
      "  # resources :users # at bottom after divise\n" +
      "  resources :profiles\n" +
      "  resources :rights\n" +
      "  resources :teams\n" +
      "  resources :companies\n" +
      "  root to: 'visitors#index'\n" +
      "  #{generator_label_rb} Ende\n"
    end

    insert_into_file "config/routes.rb",
                     :after => "devise_for :users\n" do
      "\n  #{generator_label_rb} Start\n" +
      "  resources :users\n" +
      "  #{generator_label_rb} Ende\n"
    end
    
    insert_into_file "app/assets/javascripts/application.js",
                     :before => "//= require_tree ." do
      "\n//= require bootstrap-sprockets\n"
    end
    copy_keep "app/assets/javascripts/companies.coffee", "app/assets/javascripts/companies.coffee"
    copy_keep "app/assets/javascripts/teams.coffee", "app/assets/javascripts/teams.coffee"
    copy_keep "app/assets/javascripts/profiles.coffee", "app/assets/javascripts/profiles.coffee"
    copy_keep "app/assets/javascripts/rights.coffee", "app/assets/javascripts/rights.coffee"

    copy_keep "app/assets/stylesheets/framework_and_overrides.css.scss", "app/assets/stylesheets/framework_and_overrides.css.scss"
    copy_keep "app/assets/stylesheets/scaffolds.scss", "app/assets/stylesheets/scaffolds.css.scss"
    
    # I had errors with these. Then you have to copy by hand.
    copy_keep "config/locales/accounting.en.yml", "config/locales/accounting.en.yml"
    copy_keep "config/locales/accounting.de.yml", "config/locales/accounting.de.yml"
    copy_keep "config/locales/helpers.en.yml", "config/locales/helpers.en.yml"
        
  end # generate_jumaccount 
  
  def generator_label
    # Datum führt zu "conflict" statt "identical" beim Generieren
    # "<%# Generated by jumindex_generator " + DateTime.now.to_s + " %>"
    "<%# Generated by jumaccount_generator " + @@gen_version + " %>"
  end

  def generator_label_js
    # Datum führt zu "conflict" statt "identical" beim Generieren
    # "<%# Generated by jumindex_generator " + DateTime.now.to_s + " %>"
    "// Generated by jumaccount_generator " + @@gen_version
  end
  def generator_label_rb
    # Datum führt zu "conflict" statt "identical" beim Generieren
    # "<%# Generated by jumindex_generator " + DateTime.now.to_s + " %>"
    "# Generated by jumaccount_generator " + @@gen_version
  end
  def application_name
    application_name_in.downcase
  end
  def db_name
    application_name_in.downcase
  end
  def git_repo_name
    application_name_in.downcase
  end
#  def staging_name
#    staging_name_or_ip_in
#  end

  private
  def colorize(text, color_code)
    "\033[#{color_code}m#{text}\033[0m"
  end
  def red(text); colorize(text, 31); end
  def green(text); colorize(text, 32); end
  def yellow(text); colorize(text, 33); end
  def blue(text); colorize(text, 34); end
  def magenta(text); colorize(text, 35); end

  def template_keep(source, goal)
    if ( ! File.file?(goal) )
      template source, goal
    else
      puts magenta("   unchanged  ") + goal
    end
  end
  def copy_keep(source, goal)
    if ( ! File.file?(goal) )
      copy_file source, goal
    else
      puts magenta("   unchanged  ") + goal
    end
  end

  def create_file_keep(goal, content)
    if ( ! File.file?(goal) )
      create_file goal, "w" do content  end
    else
      puts magenta("   unchanged  ") + goal
    end
  end

end
