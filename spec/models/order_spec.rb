require 'spec_helper'

RSpec.describe Order, type: :model do
  	let(:order) { FactoryGirl.build :order }
	subject {order}
	
	it { should respond_to(:total) }
	it { should respond_to(:user_id) }
	
	it { should validate_presence_of :user_id }
	
	it { should belong_to :user }
	
	it { should have_many(:placements) }
	it { should have_many(:products).through(:placements) }
	
	
	describe '#set_total!' do
		before(:each) do
			product_1 = FactoryGirl.create :product, price: "100"
			product_2 = FactoryGirl.create :product, price: 85
			
			@order = FactoryGirl.build :order, product_ids: [product_1.id, product_2.id]
		end
		
		it "returns the total amount to pay for the products" do
			@order.set_total!.should eql(185)
		end
	end
	
	describe "#build_placements_with_product_ids_and_queantities" do
		before(:each) do
			product_1 = FactoryGirl.create :product, price: 100, quantity: 5
			product_2 = FactoryGirl.create :product, price: 85, quantity: 10
			
			@product_ids_and_quantities = [[product_1.id, 2], [product_2.id, 3]]
		end
		
		it "builds 2 placements for the order" do
			order.build_placements_with_products_ids_and_quantities(@product_ids_and_quantities)
			order.placements.size.should eql(2)
		end
	end
end
