class PagesController < ApplicationController
  def home
    @top_categories = Category.top_categories
    @blogs = Blog.new_articles_for_home
    @sliders = SliderCatalog.where(image_type: "slider")
    @catalogs = SliderCatalog.where(image_type: "catalog").limit Settings.limit.catalog
    @product_labels = Label.all.order(:block_order)
      .includes(products: [:product_images, :categories]).limit Settings.limit.label_block
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL")
      .order(:home_order)
    get_home_category
  end

  def get_home_category
    @home_blocks = [home_block_1, home_block_2]
  end

  private
  (1..2).each do |i|
    define_method"home_block_#{i}" do
      categories = Category.where(level: Settings.category.middle_level)
        .where(home_block_id: i).order(:home_order_id)
        .limit(Settings.limit.home_block_category)
      home_block_arr = []
      categories.each do |category|
        products = category.list_home_products
        if products.size > 0
          home_block_arr << {title: category.name, id: category.id,
            products: products}
        end
      end
      home_block_arr
    end
  end
end
