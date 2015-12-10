json.array!(@freshnesses) do |freshness|
  json.extract! freshness, :id, :name, :freshness
  json.url freshness_url(freshness, format: :json)
end
