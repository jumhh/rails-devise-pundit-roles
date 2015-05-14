json.array!(@profiles) do |profile|
  json.extract! profile, :id, :profile_first_name, :profile_last_name, :user_id
  json.url profile_url(profile, format: :json)
end
