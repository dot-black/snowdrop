#Managers
Manager.create email: "manager@snowdrop.com", password: "qweqweqwe"

#Categories
Dir.glob(Rails.root.join("app/assets/images/categories/*")).each do |category|
  current_category = category.split("/").last
  Category.create(
    title: "#{current_category.capitalize}",
    image: Rails.root.join("app/assets/images/categories/#{current_category}/#{current_category}.jpg").open,
    visible: [true, false].sample,
    complex: current_category == "bodysuite" ? true : false
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
  sizes = {
    complex: { bra: Product.sizes[:bra].sample(5), standard: Product.sizes[:standard].sample(3) },
    bra: { bra: Product.sizes[:bra].sample(5) },
    standard: { standard: Product.sizes[:standard].sample(3) }
  }
  Product.create(
    title: row.first,
    description: IO.read( "public/sample_description.txt" ),
    price: rand(1000),
    visible: [true, false].sample,
    category_id: id = Category.ids.sample,
    sizes: ( Category.find(id).complex ? sizes[:complex] : ( Category.find(id).title.downcase == "bra" ? sizes[:bra] : sizes[:standard] )),
    archive: [true, false].sample,
    images: images
  )
  break if $. > 20
end

#Orders and Carts
10.times do |count|
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
    size: ( product.category.complex ? { bra: product.sizes["bra"].sample , brief: product.sizes["standard"].sample } : product.category.title.downcase == "bra" ? { bra: product.sizes["bra"].sample } : { standard: product.sizes["standard"].sample } ),
    quantity: rand(1..10),
    order_id: Order.ids.sample
  )
end

Order.all.each do |order|
  order.update amount: order.line_items.map(&:product).map(&:price).zip(order.line_items.map(&:quantity)).map{|x, y| x * y }.inject(0, &:+)
end

Order.where(amount: 0).each { |order| order.destroy }
