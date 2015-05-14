# <%= generator_label_rb %>
class Company < ActiveRecord::Base
  validates  :company_name, presence: true, uniqueness: true
end
