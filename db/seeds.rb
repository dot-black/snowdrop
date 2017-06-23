#Managers
Manager.create email: "manager@snowdrop.com", password: "qweqweqwe"

#Categories
Dir.glob(Rails.root.join("app/assets/images/categories/*")).each do |category|
  current_category = category.split("/").last
  Category.create(
    title: "#{current_category.capitalize}",
    image: Rails.root.join("app/assets/images/categories/#{current_category}/#{current_category}.jpg").open,
    visible: [true, false].sample
  )
end

#Products
require 'csv'
CSV.foreach("public/example-names.csv") do |row|
  images = []
  ["main", "add"].each do |item|
    image = Pathname.new("#{Rails.root.join("app/assets/")}images/products/example-pictures/#{item}-#{$.}.jpg")
    images << image.open if image.exist?
  end
  Product.create(
    title: row.first,
    description: IO.read( "public/sample_description.txt" ),
    price: rand(1000),
    visible: [true, false].sample,
    sizes: [rand(1..2), rand(3..4)],
    category_id: Category.ids.sample,
    archive: [true, false].sample,
    images: images
  )
end

#Orders and Carts
100.times do |count|
  Cart.create!
  Order.create!(
    name:"User-#{count}",
    email:"user#{count}@mail.com",
    telephone: "38063475#{rand(1000..9999)}",
    comment: IO.read( "public/sample_description.txt" ),
    status: Order.statuses.values.sample
  )
end

#LineItems
Product.order("RANDOM()").limit(50).each do |product|
  LineItem.create!(
    cart_id: Cart.ids.sample,
    product_id: product.id,
    size: product.sizes.sample,
    quantity: rand(1..10),
    order_id: Order.ids.sample
  )
end

Order.all.each do |order|
  order.update amount: order.line_items.map(&:product).map(&:price).zip(order.line_items.map(&:quantity)).map{|x, y| x * y }.inject(0, &:+)
end

Order.where(amount: 0).each { |order| order.destroy }
