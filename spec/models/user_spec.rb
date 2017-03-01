require 'spec_helper'

RSpec.describe User, type: :model do
  	before { @user = FactoryGirl.build(:user) }
	
	subject { @user }
	
	it { should respond_to(:email) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	
	it {should be_valid}

	it { should validate_presence_of(:email) }
	it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
	it { should validate_confirmation_of(:password) }
	it { should allow_value('example@domain.com').for(:email) }
	
	
	it { should respond_to(:auth_token) }
	
	it { should have_many(:products) }
	it { should have_many(:orders) }
	
	describe "#generate_authentication_token!" do
		it "generates a unique token" do 
			Devise.stub(:friendly_token).and_return("auniquetoken123")
			@user.generate_authentication_token!
			@user.auth_token.should eql "auniquetoken123"
		end
		
		it "generates another token when one already has been taken" do
			existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
			@user.generate_authentication_token!
			@user.auth_token.should_not == existing_user.auth_token
		end
	end
	
	it { should validate_uniqueness_of(:auth_token) }
	
	it { should have_many(:products) }
	
	describe "#products association" do
		
		before do
			@user2 = FactoryGirl.create :user
			3.times { FactoryGirl.create :product, user: @user2 }
		end
		
		it "should destroy the associated products on self destruct" do
			products = @user2.products
			@user2.destroy
			products.each do |product|
				Product.find(product).should raise_error ActiveRecord::RecordNotFound
			end
		end
		
	end
	
end
