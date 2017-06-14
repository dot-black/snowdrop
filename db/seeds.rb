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
