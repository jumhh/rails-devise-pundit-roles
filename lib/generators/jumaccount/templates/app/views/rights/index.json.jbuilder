json.array!(@rights) do |right|
  json.extract! right, :id, :right_role, :user_id, :company_id, :team_id
  json.url right_url(right, format: :json)
end
