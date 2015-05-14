json.array!(@companies) do |company|
  json.extract! company, :id, :company_name
  json.url company_url(company, format: :json)
end
