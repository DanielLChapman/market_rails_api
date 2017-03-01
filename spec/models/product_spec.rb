require 'rails_helper'

RSpec.describe Product, type: :model do
	let(:product) { FactoryGirl.build :product }
	subject { product }
	
	it {should respond_to(:title) }
	it { should respond_to(:price) }
	it { should respond_to(:published) }
	it { should respond_to(:user_id) }
	
	it { should be_valid}
	
	it { should validate_presence_of :title }
	it { should validate_presence_of :price }
	it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
	it { should validate_presence_of :user_id }
	
	it { should belong_to :user }
	
	describe ".filter_by_title" do
		before(:each) do
			@product1 = FactoryGirl.create :product, title: "A plasma TV"
			@product2 = FactoryGirl.create :product, title: "Fastest Laptop"
			@product3 = FactoryGirl.create :product, title: "CD Player"
			@product4 = FactoryGirl.create :product, title: "LCD TV"
		end
		
		context "when a 'TV' title pattern is sent" do
			it "returns the 2 products matching" do
				Product.filter_by_title("TV").length.should eql(2)
			end
			
			it "returns the product matching" do
				Product.filter_by_title("TV").sort.should match_array([@product1, @product4])
			end
		end
	end
	
	describe ".above_or_equal_to_price" do
		before(:each) do
		  	@product1 = FactoryGirl.create :product, price: 100
		  	@product2 = FactoryGirl.create :product, price: 50
		  	@product3 = FactoryGirl.create :product, price: 150
		  	@product4 = FactoryGirl.create :product, price: 99
		end

		it "returns the products which are above or equal to the price" do
			Product.above_or_equal_to_price(100).sort.should match_array([@product1, @product3])
		end
	end
	
	describe ".below_or_equal_to_price" do
		before(:each) do
		  	@product1 = FactoryGirl.create :product, price: 100
		  	@product2 = FactoryGirl.create :product, price: 50
		  	@product3 = FactoryGirl.create :product, price: 150
		  	@product4 = FactoryGirl.create :product, price: 99
		end

		it "returns the products which are above or equal to the price" do
			Product.below_or_equal_to_price(99).sort.should match_array([@product2, @product4])
		end
	end
	
	describe ".recent" do
		before(:each) do
		  	@product1 = FactoryGirl.create :product, price: 100
		  	@product2 = FactoryGirl.create :product, price: 50
		  	@product3 = FactoryGirl.create :product, price: 150
		  	@product4 = FactoryGirl.create :product, price: 99
			
			@product2.touch
			@product3.touch
		end

		it "returns the products which are above or equal to the price" do
			Product.recent.should match_array([@product3, @product2, @product4, @product1])
		end
	end
	
	describe ".search" do
		before(:each) do
			@product1 = FactoryGirl.create :product, price: 100, title: "Plasma tv"
			@product2 = FactoryGirl.create :product, price: 50, title: "Videogame console"
			@product3 = FactoryGirl.create :product, price: 150, title: "MP3"
			@product4 = FactoryGirl.create :product, price: 99, title: "Laptop"
		end
		
		context "when title 'videogame' and '100' a min price are set" do
			it "returns an empty array" do
				search_hash = { keyword: "videogame", min_price: 100 }
				Product.search(search_hash).should be_empty
			end
		end
		
		context "when title 'tv' and '150' as max price, and '50' as min price are set" do
			it "returns the product1" do
				search_hash = { keyword: "tv", min_price: 50, max_price: 150 }
				Product.search(search_hash).should match_array([@product1])
			end
		end
		
		context "when an empty hasi is sent" do
			it "returns all the products" do
				Product.search({}).should match_array([@product1, @product2, @product3, @product4])
			end
		end
		
		context "when product_ids is present" do
			it "returns the product from the ids" do
				search_hash = {product_ids: [@product1.id, @product2.id]}
				Product.search(search_hash).should match_array([@product1, @product2])
			end
		end
	end
end
