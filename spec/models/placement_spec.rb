require 'spec_helper'

RSpec.describe Placement, type: :model do
  	let(:placement) { FactoryGirl.build :placement }
	subject { placement }
	
	it { should respond_to :order_id }
	it { should respond_to :product_id }
	
	it { should belong_to :order }
	it { should belong_to :product }
	
	it { should respond_to :product_id }
	it { should respond_to :quantity }
	
	describe "#decrement_product_quantity" do
		it "decreases the product quantity by the placement quantity" do
			product = placement.product
			placement.decrement_product_quantity!
			product.quantity.should eql(product.quantity-placement.quantity)
		end
	end
end
