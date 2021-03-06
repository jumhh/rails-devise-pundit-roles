# <%= generator_label_rb %>
class Right < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :team
  
  # example role names, please adopt
  enum right_role: {no_rights: 0,
                    employee: 1, 
                    external: 2,
                    manager: 3,
                    team_coach: 4 ,
                    team_master: 5
                 }

  after_initialize :init, :if => :new_record?
  validates  :user_id, presence: true
  validates  :company_id, presence: true
  validates  :team_id, presence: true

  def init
    if self.new_record?
      self.right_role ||= :no_rights
      # conflicts with validates:
      # self.user_id ||= 0
      # self.company_id ||= 0
      # self.team_id ||= 0
    end
  end


end
