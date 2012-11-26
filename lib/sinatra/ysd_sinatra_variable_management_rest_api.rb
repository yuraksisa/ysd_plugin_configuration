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
            
            query_options = {}
            conditions = {}
            
            # Search information (from body)
            if request.media_type == "application/x-www-form-urlencoded" # Just the text
              request.body.rewind
              search_text=request.body.read
              conditions = {:name.like => "%#{search_text}%"}
              query_options.store(:conditions, conditions)
            end
          
            # Paging information (from Url) 
            page_size = SystemConfiguration::Variable.get_value('configuration.variables_page_size', 20).to_i
            
            page = params[:page].to_i || 1
            limit = page_size
            offset = (page-1) * page_size        
            
            query_options.store(:limit, limit)
            query_options.store(:offset, offset)
            
            puts "query options : #{query_options.inspect}"
            
            # Do the search
            data=SystemConfiguration::Variable.all(query_options)
            
            begin # Count does not work for all adapters
              total=SystemConfiguration::Variable.count(conditions)
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