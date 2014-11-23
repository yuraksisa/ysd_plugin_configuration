require 'spec_helper'
require 'rack/test'

describe Sinatra::YSD::SecureVariableManagement do 
  include Rack::Test::Methods
  
  def app
    TestingSinatraApp.class_eval do
      register Sinatra::YSD::SecureVariableManagement
    end
    TestingSinatraApp
  end

  describe '/admin/configuration/svariable' do
   
   before :each do
     app.any_instance.should_receive(:load_page).
       with(:secure_variable_management, 
       :locals => {:secure_variable_page_size => 20}).and_return('Hello World!')
   end

   subject do 
     get '/admin/configuration/svariable'
     last_response       
   end

   its(:status) { should == 200 }

  end	

end