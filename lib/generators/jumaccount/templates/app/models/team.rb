# <%= generator_label_rb %>
class Team < ActiveRecord::Base
  validates  :team_name, presence: true, uniqueness: true
end
