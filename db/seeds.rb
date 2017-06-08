# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Manager.create email: "manager@snowdrop.com", password: "qweqweqwe"

description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
100.times do
  products_list = []
  Dir.glob("public/images/products/*").each do |product|
    images_paths = []
    current_product = product.split("/").last
    product = Product.create(
      title: "#{current_product.gsub('_',' ').capitalize}",
      description: description,
      price: rand(1000),
      visible: [true, false].sample,
      sizes: [rand(1..2), rand(3..4)],
      category: rand(1..Product.categories.size)
    )
    Dir.glob("public/images/products/#{current_product}/*.jpg").each{|image| images_paths.push Pathname.new(image).open }
    product.images = images_paths
    product.save
  end
end  
