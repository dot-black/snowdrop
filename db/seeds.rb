#Managers
Manager.create email: "manager@snowdrop.com", password: "qweqweqwe"

#Categories
Dir.glob("public/images/categories/*").each do |category|
  current_category = category.split("/").last
  Category.create(
    title: "#{current_category.capitalize}",
    image: Rails.root.join("public/images/categories/#{current_category}/#{current_category}.jpg").open,
    visible: [true, false].sample
  )
end

#Products
require 'csv'
CSV.foreach("public/example-names.csv") do |row|
  images = []
  ["main", "add"].each do |item|
    image = Pathname.new("public/images/products/example-pictures/#{item}-#{$.}.jpg")
    images << image.open if image.exist?
  end
  product = Product.create(
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
