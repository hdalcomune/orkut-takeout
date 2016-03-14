require 'rails_helper'

describe SignInController do
  let(:stubbed_sign_in_response) {
    stubbed_sign_in_response = double()
    allow(stubbed_sign_in_response).to receive(:body).and_return("my token")
    stubbed_sign_in_response
  }

  it "should render index" do
    get :index
    expect(response).to render_template("index")
  end

  it "should raise an error if invalid route is passed as parameter" do
    expect { get :export }.to raise_error ActiveRecord::RecordNotFound
  end

end
