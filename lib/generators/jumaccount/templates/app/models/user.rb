# <%= generator_label_rb %>
class User < ActiveRecord::Base
  enum user_system_role: [:user, :vip, :admin]
  after_initialize :set_default_user_system_role, :if => :new_record?
  has_many :rights
  has_one :profile
  
  def set_default_user_system_role
    self.user_system_role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
