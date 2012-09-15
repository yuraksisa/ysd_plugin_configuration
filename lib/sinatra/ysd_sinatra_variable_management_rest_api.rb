require 'ysd_md_integration'
require 'uri'
module Sinatra
  module YSD
    module VariableManagementRESTApi
   
      def self.registered(app)
                    
        #
        # Retrive all variables (GET)
        #
        app.get "/variables" do
          data=SystemConfiguration::Variable.all
  
          # Prepare the result
          content_type :json
          data.to_json
        end
        
        #
        # Retrieve variables (POST)
        #
        ["/variables","/variables/page/:page"].each do |path|
          app.post path do
          
            data=SystemConfiguration::Variable.all
            
            begin # Count does not work for all adapters
              total=SystemConfiguration::Variable.count
            rescue
              total=SystemConfiguration::Variable.all.length
            end
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Create a new variable
        #
        app.post "/variable" do
        
          puts "Creating variable"
          
          request.body.rewind
          variable_request = JSON.parse(URI.unescape(request.body.read))
          
          # Creates the new variable
          the_variable = SystemConfiguration::Variable.create(variable_request) 
          
          puts "created variable : #{the_variable}"
          
          # Return          
          status 200
          content_type :json
          the_variable.to_json          
        
        end
        
        #
        # Updates a variable
        #
        app.put "/variable" do
        
          puts "Updating variable"
        
          request.body.rewind
          variable_request = JSON.parse(URI.unescape(request.body.read))
          
          # Updates variable         
          the_variable = SystemConfiguration::Variable.get(variable_request['name'])
          the_variable.attributes=(variable_request)
          the_variable.save
          
          puts "updated variable : #{the_variable}"
                   
          # Return          
          status 200
          content_type :json
          the_variable.to_json
        
        
        end
        
        #
        # Deletes a variable
        #
        app.delete "/variable" do
        
        end
      
      end
    
    end #VariableManagementRESTApi
  end #YSD
end #Sinatra