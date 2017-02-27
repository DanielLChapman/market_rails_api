require 'spec_helper'

class Authentication
	include Authenticable
end

describe Authenticable, :type => :controller do
	let(:authentication) {Authentication.new}
	subject { authentication }
	
	describe "#current_user" do
		before do
			@user = FactoryGirl.create :user
			request.headers["Authorization"] = @user.auth_token
			authentication.stub(:request).and_return(request)
		end
		it "returns the user from the authorization header" do
			authentication.current_user.auth_token.should eql @user.auth_token
		end
	end
end
