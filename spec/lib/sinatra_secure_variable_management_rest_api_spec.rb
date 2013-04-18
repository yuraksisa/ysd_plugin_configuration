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
      SystemConfiguration::Variable.should_receive(:get_value).
          with('configuration.secure_variable_page_size').
          and_return(10) 
    end

    context "no pagination and no query" do

      before :each do
        SystemConfiguration::SecureVariable.should_receive(:all).
          with({:offset => 0, :limit => 10}).
          and_return([SystemConfiguration::SecureVariable.new(secure_variable)])
      end

      subject do
        post '/svariables', {}
        last_response
      end

      its(:status) { should == 200 } 
      its(:header) { should have_key 'Content-Type' }
      it { subject.header['Content-Type'].should match(/application\/json/) }
      its(:body) { should == [SystemConfiguration::SecureVariable.new(secure_variable)].to_json }
    
    end

    context "pagination" do

      before :each do
        SystemConfiguration::SecureVariable.should_receive(:all).
          with({:offset => 10, :limit => 10}).
          and_return([SystemConfiguration::SecureVariable.new(secure_variable)])
      end

      subject do
        post '/svariables/page/2', {}
        last_response
      end

      its(:status) { should == 200 } 
      its(:header) { should have_key 'Content-Type' }
      it { subject.header['Content-Type'].should match(/application\/json/) }
      its(:body) { should == [SystemConfiguration::SecureVariable.new(secure_variable)].to_json }

    end

    context "pagination and query" do

      before :each do
        SystemConfiguration::SecureVariable.should_receive(:all).
          with(hash_including(:conditions => {:name.like => "%text%"}, :offset => 10, :limit => 10)).
          and_return([SystemConfiguration::SecureVariable.new(secure_variable)])
      end

      subject do 
        post '/svariables/page/2', {:search => 'text'}
        last_response
      end
      
      its(:status) {should == 200}
      its(:header) {should have_key 'Content-Type'}
      it { subject.header['Content-Type'].should match(/application\/json/) }
      its(:body) { should == [SystemConfiguration::SecureVariable.new(secure_variable)].to_json }

    end

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