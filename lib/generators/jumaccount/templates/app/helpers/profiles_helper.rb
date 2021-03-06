# <%= generator_label_rb %>
module ProfilesHelper
  
  def profile_preferred_right_id_select
    x = []
    current_user.rights.each do |r| 
      x.push(["#{r.team.team_name} - #{r.right_role.titleize}", r.id])
    end
    return x
  end

  def profile_user_id_select
    x = []
    User.find_each do |u|
      puts "profile-user_id_select: #{u.profile}"
      if !(u.profile)
        x.push(["#{u.email}", u.id])
      end
    end
    return x
  end

end
