require 'spec_helper'

describe Api::V1::UsersController, :type => :controller do
  before(:each) { request.headers['Accept'] = "application/vnd.market_place_api.v1" }

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      user_response[:email].should == @user.email
    end

    it { should respond_with 200 }
  end
end