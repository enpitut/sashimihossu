json.array!(@items) do |item|
  json.extract! item, :id, :title, :amount_at_a_time, :gram_at_a_time, :price_at_a_time, :price_at_one_amount, :price_at_one_gram, :description, :icon, :user_id, :start, :end, :remaining_amount, :remaining_gram, :allDay
  json.url item_url(item, format: :json)
end
