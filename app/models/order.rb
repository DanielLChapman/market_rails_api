class Order < ActiveRecord::Base
  	belongs_to :user
	before_validation :set_total!
	
	validates :user_id, presence: true
	validates_with EnoughProductsValidator
	has_many :placements
	has_many :products, through: :placements
	
	def set_total!
    	@t = 0
    	placements.each do |placement|
      		@t = @t + (placement.product.price.to_f * placement.quantity.to_f)
    	end
		self.total = @t
  	end
	
	def build_placements_with_products_ids_and_quantities(product_ids_and_quantities)
		product_ids_and_quantities.each do |product_id_and_quantity|
			id, quantity = product_id_and_quantity # [1,5]

			self.placements.build(product_id: id, quantity: quantity)
    	end
	end

end
