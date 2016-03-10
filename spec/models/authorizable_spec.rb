require 'rails_helper'

describe Authorizable do

let(:my_token){"/this is my token/"}

  it "should stores the authentication token prepended by baerer" do
      #setup
      expected_token = "this is my token"
      #exercise
      Authorizable.set_token my_token
      #verify
      expect(Authorizable.get_token).to eq "bearer " + expected_token
      #teardown -- don't need to worry since we're not changing persistent data
  end

  it "should sign in when I have a token stored" do
    Authorizable.set_token my_token
    expect(Authorizable).to be_signed_in
    #expect(Authorizable).to_not be_signed_in
  end

  it "should sign out when I dont have a token stored" do
    #setup
    Authorizable.set_token my_token
    #exercise
    Authorizable.clear_token
    #verify
    expect(Authorizable).to_not be_signed_in
    expect(Authorizable.get_token).to be_nil
  end

end
