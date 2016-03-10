require 'rails_helper'

describe OrkutClient do

  let(:sign_in_response){
    sign_in_response = double ()
    allow(sign_in_response).to receive(:body).and_return("my token")
    sign_in_response
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

  it "should return current user info" do
    #Using server
    orkut_client = OrkutClient.new
    orkut_client.sign_in("hdalcomune@avenuecode.com","testuser")
    expect(orkut_client.get_current_user_info).to be_a(Hash)

    #setup
    # user_info_response = double ()
    # orkut_client = OrkutClient.new
    # allow(RestClient).to receive(:post).and_return(sign_in_response)
    # orkut_client.sign_in("hdalcomune@avenuecode.com","testuser")
    # Authorizable.set_token "my token"
    # expect(RestClient).to receive(:get).with(/users\/me/, hash_including(method: :get, url: "http://test/users/me", headers: { Authorization: "my token" } )).and_return(user_info_response)
    # #expect(RestClient).to receive(:get).and_return(user_info_response)
    # orkut_client.get_current_user_info
  end

  it "should return friends list" do
    orkut_client = OrkutClient.new
    orkut_client.sign_in("hdalcomune@avenuecode.com","testuser")
    expect(orkut_client.get_my_friends).to be_a(Hash)
  end

end
