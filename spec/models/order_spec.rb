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
			  product_1 = FactoryGirl.create :product, price: 100
			  product_2 = FactoryGirl.create :product, price: 85

			  placement_1 = FactoryGirl.build :placement, product: product_1, quantity: 3
			  placement_2 = FactoryGirl.build :placement, product: product_2, quantity: 15

			  @order = FactoryGirl.build :order

			  @order.placements << placement_1
			  @order.placements << placement_2
		end
		
		it "returns the total amount to pay for the products" do
			@order.set_total!
			@order.total.should eql(1575)
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
	
	describe "#build_placements_with_product_ids_and_quantities" do
	end

	describe "#valid?" do
		before do
		  	product_1 = FactoryGirl.create :product, price: 100, quantity: 5
		  	product_2 = FactoryGirl.create :product, price: 85, quantity: 10


		  	placement_1 = FactoryGirl.build :placement, product: product_1, quantity: 3
		  	placement_2 = FactoryGirl.build :placement, product: product_2, quantity: 15

		  	@order = FactoryGirl.build :order

		  	@order.placements << placement_1
		  	@order.placements << placement_2
		end

		it "becomes invalid due to insufficient products" do
		  @order.should_not be_valid
		end
	  end
end
