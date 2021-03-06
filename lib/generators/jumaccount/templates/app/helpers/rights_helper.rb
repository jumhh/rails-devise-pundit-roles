# <%= generator_label_rb %>
module RightsHelper
  
  def right_company_id_select
    x = []
    Company.find_each do |c|
      x.push(["#{c.company_name}", c.id])
    end
    return x
  end
  
  def right_team_id_select
    x = []
    Team.find_each do |t|
      x.push(["#{t.team_name}", t.id])
    end
    return x
  end

  def right_user_id_select
    x = []
    User.find_each do |u|
      x.push(["#{u.email}", u.id])
    end
    return x
  end

end
