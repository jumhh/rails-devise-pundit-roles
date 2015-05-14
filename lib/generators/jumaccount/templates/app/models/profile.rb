# <%= generator_label_rb %>
class Profile < ActiveRecord::Base
  belongs_to :user
  validates  :user_id, presence: true

end
