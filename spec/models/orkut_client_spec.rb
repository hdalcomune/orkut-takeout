require 'rails_helper'

describe OrkutClient do

  let(:sign_in_response){
    sign_in_response = double ()
    allow(sign_in_response).to receive(:body).and_return("my token")
    sign_in_response
  }

  let(:user_info_response){
    user_info_response = double()
    allow(user_info_response).to receive(:body).and_return("{}")
    user_info_response
  }

  let(:my_friends_info){
      my_friends_info = double()
      allow(my_friends_info).to receive(:body).and_return("{}")
      my_friends_info
  }

  it "should sign in to Orkut Server" do
    #setup
    orkut_client = OrkutClient.new
    #verify
    expect(RestClient).to receive(:post).with(/login/, hash_including(username: "hdalcomune@avenuecode.com", password: "testuser" )).and_return(sign_in_response)
    #exercise
    response = orkut_client.sign_in("hdalcomune@avenuecode.com","testuser")
    expect(Authorizable).to be_signed_in
  end

  it "should sign out from Orkut Server" do
    #setup
    orkut_client = OrkutClient.new
    allow(RestClient).to receive(:post).and_return(sign_in_response)
    orkut_client.sign_in("user","password")
    #exercise
    orkut_client.sign_out
    #verify
    expect(Authorizable).to_not be_signed_in
  end

  context "get_current_user_info" do

    it "should throw an exception when user is not signed in" do
      orkut_client = OrkutClient.new
      expect{ orkut_client.get_current_user_info }.to raise_error(/user not signed in/)
    end

    it "should return current user info" do
      #Using server
      # orkut_client = OrkutClient.new
      # orkut_client.sign_in("hdalcomune@avenuecode.com","testuser")
      # expect(orkut_client.get_current_user_info).to be_a(Hash)

      allow(Authorizable).to receive(:signed_in?).and_return(true)
      allow(Authorizable).to receive(:get_token).and_return("my token")
      orkut_client = OrkutClient.new

      expect(RestClient::Request).to receive(:execute).with(hash_including(method: :get, url: /users\/me/, headers: { Authorization: "my token" } )).and_return(user_info_response)
      expect(orkut_client.get_current_user_info).to be_a(Hash)
    end
  end

  context "get_my_friends" do

    it "should throw an exception when user is not signed in" do
      orkut_client = OrkutClient.new
      expect{ orkut_client.get_my_friends }.to raise_error(/user not signed in/)
    end

    it "should return friends list" do
      # Using server
      # orkut_client = OrkutClient.new
      # orkut_client.sign_in("hdalcomune@avenuecode.com","testuser")
      # expect(orkut_client.get_my_friends).to_not be_a(Hash)

      allow(Authorizable).to receive(:signed_in?).and_return(true)
      allow(Authorizable).to receive(:get_token).and_return("my token")
      orkut_client = OrkutClient.new

      expect(RestClient::Request).to receive(:execute).with(hash_including(method: :get, url: /friendships\/me/, headers: { Authorization: "my token"})).and_return(my_friends_info)
      expect(orkut_client.get_my_friends).to be_a(Hash)
    end

  end

end
