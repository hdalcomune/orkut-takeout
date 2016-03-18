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

  it "should redirect to first_social_media when social_network_1 is passed as parameter" do
    get :export, { :export => 'social_network_1'}
    expect(response).to be_redirect
    expect(response).to redirect_to /first-social-media/
  end

  it "should redirect to second_social_media when social_network_2 is passed as parameter" do
    get :export, { :export => 'social_network_2'}
    expect(response).to be_redirect
    expect(response).to redirect_to /second-social-media/
  end

  it "should redirect to third_social_media when social_network_3 is passed as parameter" do
    get :export, { :export => 'social_network_3'}
    expect(response).to be_redirect
    expect(response).to redirect_to /third-social-media/
    # expect(response.body).to include 'social_network_3'
  end
end
