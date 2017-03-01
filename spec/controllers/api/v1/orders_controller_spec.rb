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
			@order = FactoryGirl.create :order, user: current_user
			get :show, user_id: current_user.id, id: @order.id
		end
		
		it "returns the user order record matching the id" do
			order_response = json_response
			order_response[:id].should eql @order.id
		end
		
		it { should respond_with 200 }
	end
end
