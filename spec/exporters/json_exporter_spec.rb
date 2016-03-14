require 'rails_helper'

describe JSONExporter do
  let(:exporter) { JSONExporter.new }
  let(:current_user_hash){
    {
      "_id" => "56df40b193a9a845256d306b",
      "provider" => "local",
      "name" => "Henrique Dalcomune",
      "email" => "hdalcomune@avenuecode.com",
      "password" => "testuser",
      "__v" => 0,
      "role" => "user"
    }
  }
  let(:friendly_hash) {
    JSON.parse(%Q([{"_id":"56ab7fc22e481306042c151d","user":{"_id":"56ab7ee72e481306042c1518","name":"QA Couse User 1","email":"qacourseuser1@avenuecode.com"}},{"_id":"56ab7fd22e481306042c151e","user":{"_id":"56ab7ef12e481306042c1519","name":"QA Couse User 2","email":"qacourseuser2@avenuecode.com"}},{"_id":"56ab7fd82e481306042c151f","user":{"_id":"56ab7efb2e481306042c151a","name":"QA Couse User 3","email":"qacourseuser3@avenuecode.com"}},{"_id":"56ab7fe22e481306042c1520","user":{"_id":"56ab7f042e481306042c151b","name":"QA Couse User 4","email":"qacourseuser4@avenuecode.com"}},{"_id":"56ab7fec2e481306042c1521","user":{"_id":"56ab7f102e481306042c151c","name":"QA Couse User 5","email":"qacourseuser5@avenuecode.com"}}]))
  }
  let(:not_so_friendly_hash){
    friends_array = []
    4.times do
      friends_array << %Q({
	                       "_id": "56ab7fc22e481306042c151d",
                          "user": {
                                  "_id": "56ab7ee72e481306042c1518",
                                  "name": "QA Couse User 1",
                                  "email": "qacourseuser1@avenuecode.com"
	                               }
                         })
    end
    friends_string = friends_array.join(",")
    JSON.parse("[#{friends_string}]")
  }
  let(:super_friendly_hash){
    friends_array = []
    13.times do
      friends_array << %Q({
	                       "_id": "56ab7fc22e481306042c151d",
                          "user": {
                                  "_id": "56ab7ee72e481306042c1518",
                                  "name": "QA Couse User 1",
                                  "email": "qacourseuser1@avenuecode.com"
	                               }
                         })
    end
    friends_string = friends_array.join(",")
    JSON.parse("[#{friends_string}]")
  }

  context "should export my friends in JSON format" do
    it "should say my social type is Friendly" do
      response = exporter.export_friends(friendly_hash, current_user_hash)
      response = JSON.parse(response)
      expect(response["user"]["socialType"]).to eq("Friendly")
      expect(response["user"]["socialPercentage"].to_i).to be > 30 and be <= 80
    end

    it "should say my social type is Not So Friendly" do
      response = exporter.export_friends(not_so_friendly_hash, current_user_hash)
      response = JSON.parse(response)
      expect(response["user"]["socialType"]).to eq("Not So Friendly")
      expect(response["user"]["socialPercentage"].to_i).to be <= 30
    end

    it "should say my social type is Super Friendly" do
      response = exporter.export_friends(super_friendly_hash, current_user_hash)
      response = JSON.parse(response)
      expect(response["user"]["socialType"]).to eq("Super Friendly")
      expect(response["user"]["socialPercentage"].to_i).to be > 80
    end
  end

end
