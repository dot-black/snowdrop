# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Manager.create email: "manager@snowdrop.com", password: "qweqweqwe"

Dir.glob("public/images/categories/*").each do |category|
  current_category = category.split("/").last
  Category.create(
    title: "#{current_category.capitalize}",
    image: Rails.root.join("public/images/categories/#{current_category}/#{current_category}.jpg").open,
    visible: [true, false].sample,
    archive: [true, false].sample
  )
end

100.times do
  products_list = []
  Dir.glob("public/images/products/*").each do |product|
    images_paths = []
    current_product = product.split("/").last
    product = Product.create(
      title: "#{current_product.gsub('_',' ').capitalize}",
      description: IO.read( "public/sample_description.txt" ),
      price: rand(1000),
      visible: [true, false].sample,
      sizes: [rand(1..2), rand(3..4)],
      category_id: Category.ids.sample,
      archive: [true, false].sample
    )
    Dir.glob("public/images/products/#{current_product}/*.jpg").each{|image| images_paths.push Pathname.new(image).open }
    product.images = images_paths
    product.save
  end
end
