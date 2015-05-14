# <%= generator_label_rb %>
module CurrentAuthority

  # Pundit Additional Context
  
  class CurrentAuthority
    attr_reader :user, :right

    def initialize(user, right)
      @user = user
      @right = right
    end
  end # CurrentAuthority
  
end