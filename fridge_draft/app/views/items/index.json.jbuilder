json.array!(@items) do |item|
  json.extract! item, :id, :name, :amount_at_a_time, :gram_at_a_time, :price_at_a_time, :price_at_one_amount, :price_at_one_gram, :description, :icon
  json.url item_url(item, format: :json)
end
