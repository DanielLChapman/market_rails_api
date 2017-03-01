require 'spec_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
	describe "Get #index" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token
			4.times { FactoryGirl.create :order, user: current_user }
			get :index, user_id: current_user.id
		end
		
		it "returns 4 order records from the user" do
			orders_response = json_response
			orders_response.length.should == 4
		end
		
		it {should respond_with 200}
	end
	
	describe "Get #show" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token
			@product = FactoryGirl.create :product
    		@order = FactoryGirl.create :order, user: current_user, product_ids: [@product.id]
    		get :show, user_id: current_user.id, id: @order.id

		end
		
		it "returns the user order record matching the id" do
			order_response = json_response
			order_response[:id].should eql @order.id
		end
		
		it { should respond_with 200 }
		
		it "includes teh total for the order" do
			order_response = json_response
			order_response[:total].should eql @order.total.to_s
		end
		
		it "includes the products on the oder" do
			order_response = json_response
			order_response[:products].length.should eql(1)
		end
	end
	
	describe "POST #create" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token
			
			product_1 = FactoryGirl.create :product
			product_2 = FactoryGirl.create :product
			order_params = { product_ids_and_quantities: [[product_1.id, 2],[ product_2.id, 3]] }
			post :create, user_id: current_user.id, order: order_params
		end
		
		it "returns the just user order record" do
			order_response = json_response
			order_response[:id].should be_present
		end
		
		it "embeds the two product objects related ot the order" do
			order_response = json_response
			order_response[:products].size.should eql(2)
		end
		
		it {should respond_with 201 }
	end
end
