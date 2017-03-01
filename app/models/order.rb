class Order < ActiveRecord::Base
  	belongs_to :user
	before_validation :set_total!
	
	validates :user_id, presence: true
	
	has_many :placements
	has_many :products, through: :placements
	
	def set_total!
		self.total = products.map(&:price).sum
	end


end
