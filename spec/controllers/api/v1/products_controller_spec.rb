require 'spec_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
	describe "GET #show" do
		before(:each) do
			@product = FactoryGirl.create :product
			get :show, id: @product.id
		end
		
		it "Returns the information about a reporter on a hash" do
			product_response = json_response
			product_response[:title].should eql @product.title
		end
		
		it {should respond_with 200 }
	end
	
	describe "Get #index" do
		before(:each) do
			4.times { FactoryGirl.create :product }
			get :index
		end
		
		it "returns 4 records from the database" do
			products_response = json_response
			products_response.length.should eql(4)
		end
		
		it {should respond_with 200 }
	end
	
	describe "POST #create" do
		context "when is successfully created" do
			before(:each) do
				user = FactoryGirl.create :user
				@product_attributes = FactoryGirl.attributes_for :product
				api_authorization_header user.auth_token
				post :create, {user_id: user.id, product: @product_attributes }
			end
			
			it "renders the json representation for the product record just created" do
				product_response = json_response
				product_response[:title].should eql @product_attributes[:title]
			end
			
			it { should respond_with 201 }
		end
		
		context "when is not created" do
			before(:each) do
				user = FactoryGirl.create :user
				@invalid_product_attributes = { title: "Smart TV", price: "Twelve Dollars" }
				api_authorization_header user.auth_token
				post :create, { user_id: user.id, product: @invalid_product_attributes }
			end
			
			it "renders an errors json" do
				product_response = json_response
				product_response.should have_key(:errors)
			end
			
			it "renders the json errors on why the user could not be created" do
				product_response = json_response
				product_response[:errors][:price].should include "is not a number"
			end
			it {should respond_with 422}
		end
	end
	
	describe "PUT/PATCH #update" do
		before(:each) do
			@user = FactoryGirl.create :user
			@product = FactoryGirl.create :product, user: @user
			api_authorization_header @user.auth_token
		end
		
		context "when is successfully updated" do
			before(:each) do
				patch :update, {user_id: @user.id, id: @product.id, product: {title: "An expensive TV" } }
			end
			
			it "renders the json representation for the updated user" do
				product_response = json_response
				product_response[:title].should eql "An expensive TV"
			end
			
			it { should respond_with 200 }
		end
		
		context "When is not updated" do
			before(:each) do
				patch :update, {user_id: @user.id, id: @product.id, product: {price: "Twelve" } }
			end
			
			it "renders an error json" do
				product_response = json_response
				product_response.should have_key(:errors)
			end
			
			it "renders the json errors on why the user could not be created" do
				product_response = json_response
				product_response[:errors][:price].should include "is not a number"
			end
			
			it { should respond_with 422 }
		end
	
	
	end
	
	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			@product = FactoryGirl.create :product, user: @user
			api_authorization_header @user.auth_token
			delete :destroy, { user_id: @user.id, id: @product.id }
		end
		
		it { should respond_with 204 }
	end
end
