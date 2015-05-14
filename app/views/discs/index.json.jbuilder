json.array!(@discs) do |disc|
  json.extract! disc, :id, :feld1, :feld2, :team
  json.url disc_url(disc, format: :json)
end
