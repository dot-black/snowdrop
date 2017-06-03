# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Manager.create email: "manager@snowdrop.com", password: "qweqweqwe"

products_list = []
Dir.glob("public/images/products/*").each do |product|
  images_paths = []
  current_product = product.split("/").last
  product = Product.create(title: "#{current_product.gsub('_',' ').capitalize}", description: "Apple product", price: rand(1000))
  Dir.glob("public/images/products/#{current_product}/*.jpg").each{|image| images_paths.push Pathname.new(image).open }
  product.images = images_paths
  product.save
end
