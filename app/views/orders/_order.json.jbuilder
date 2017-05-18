json.extract! order, :id, :name, :payment_method, :comment, :created_at, :updated_at
json.url order_url(order, format: :json)
