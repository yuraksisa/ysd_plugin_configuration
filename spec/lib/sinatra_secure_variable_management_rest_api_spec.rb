require 'spec_helper'
require 'rack/test'
require 'ysd_md_configuration'
require 'json'

describe Sinatra::YSD::SecureVariableManagementRESTApi do
  include Rack::Test::Methods

  let(:secure_variable) do
  	 {:name => 'variable',
      :value => '1234',
      :module => 'configuration',
      :description => 'configuration variable'}
  end
  
  def app
    TestingSinatraApp.class_eval do
      register Sinatra::YSD::SecureVariableManagementRESTApi
    end
    TestingSinatraApp
  end

  describe "POST /svariables" do

    before :each do
      SystemConfiguration::SecureVariable.should_receive(:all).and_return(
      	[SystemConfiguration::SecureVariable.new(secure_variable)])
    end

    subject do
      post '/svariables'
      last_response
    end

    its(:status) { should == 200 } 
    its(:header) { should have_key 'Content-Type' }
    it { subject.header['Content-Type'].should match(/application\/json/) }
    its(:body) { should == [SystemConfiguration::SecureVariable.new(secure_variable)].to_json }

  end

  #describe "POST /svariable" do
  #
  #end

  #describe "PUT /svariable" do
  #
  #end

  #describe "DELETE /svariable" do
  #
  #end

end