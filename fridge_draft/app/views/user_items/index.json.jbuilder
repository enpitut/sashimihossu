json.array!(@user_items) do |user_item|
  json.extract! user_item, :id, :user_id, :item_id, :remaining_amount, :remaining_gram, :title, :start, :end
  json.url user_item_url(user_item, format: :json)
end
