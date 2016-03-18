require 'rails_helper'

describe ThirdSocialMediaController do
  let(:stubbed_sign_in_response) {
    stubbed_sign_in_response = double()
    allow(stubbed_sign_in_response).to receive(:body).and_return("my token")
    stubbed_sign_in_response
  }
  let(:current_user_json){
    %Q({
      "_id":"56df40b193a9a845256d306b",
      "provider":"local",
      "name":"Henrique Dalcomune",
      "email":"hdalcomune@avenuecode.com",
      "password":"testuser",
      "__v":0,
      "role":"user"
    })
  }
  let(:friends_json) {
    %Q([{"_id":"56ab7fc22e481306042c151d","user":{"_id":"56ab7ee72e481306042c1518","name":"QA Couse User 1","email":"qacourseuser1@avenuecode.com"}},{"_id":"56ab7fd22e481306042c151e","user":{"_id":"56ab7ef12e481306042c1519","name":"QA Couse User 2","email":"qacourseuser2@avenuecode.com"}},{"_id":"56ab7fd82e481306042c151f","user":{"_id":"56ab7efb2e481306042c151a","name":"QA Couse User 3","email":"qacourseuser3@avenuecode.com"}},{"_id":"56ab7fe22e481306042c1520","user":{"_id":"56ab7f042e481306042c151b","name":"QA Couse User 4","email":"qacourseuser4@avenuecode.com"}},{"_id":"56ab7fec2e481306042c1521","user":{"_id":"56ab7f102e481306042c151c","name":"QA Couse User 5","email":"qacourseuser5@avenuecode.com"}}])
  }
  let(:user_stubbed_response){
    user_stubbed_response = double()
    allow(user_stubbed_response).to receive(:body).and_return(current_user_json)
    user_stubbed_response
  }
  let(:friends_stubbed_response){
    friends_stubbed_response = double()
    allow(friends_stubbed_response).to receive(:body).and_return(friends_json)
    friends_stubbed_response
  }

  it "should raise an error if login parameters are not passed" do
    expect {get :export}.to raise_error(/User missing/)
  end

  it "should export my data to JSON format when I enter my credentials" do
    allow(RestClient).to receive(:post).and_return(stubbed_sign_in_response)
    allow(RestClient::Request).to receive(:execute).with(hash_including(url:/friendships\/me/)).and_return(friends_stubbed_response)
    allow(RestClient::Request).to receive(:execute).with(hash_including(url:/users\/me/)).and_return(user_stubbed_response)

    get :export, user: "my_user", password: "my_password"
    json_response = JSON.parse(response.body)
    expect(json_response["user"]["name"]).to include "Henrique Dalcomune"
    expect(json_response["user"]["email"]).to include "hdalcomune@avenuecode.com"
    expect(json_response["friends"][0]["name"]).to include "QA Couse User 1"
    expect(json_response["friends"][0]["email"]).to include "qacourseuser1@avenuecode.com"
    expect(json_response["friends"].size).to eq 5
  end

end
