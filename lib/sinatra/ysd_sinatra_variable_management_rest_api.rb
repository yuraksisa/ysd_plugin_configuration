require 'ysd_md_configuration'
require 'uri'
module Sinatra
  module YSD
    module VariableManagementRESTApi
   
      def self.registered(app)
                    
        #
        # Retrive all variables (GET)
        #
        app.get "/api/variables", :allowed_usergroups => ['staff','webmaster'] do
          data=SystemConfiguration::Variable.all
  
          # Prepare the result
          content_type :json
          data.to_json
        end
        
        #
        # Retrieve variables (POST)
        #
        ["/api/variables","/api/variables/page/:page"].each do |path|
          app.post path, :allowed_usergroups => ['staff','webmaster'] do
            
            query_options = {}
            conditions = {}
            
            if request.media_type == "application/json" # Just the text
              request.body.rewind
              search_request = JSON.parse(URI.unescape(request.body.read))
              if search_request.has_key?('search')
                query_options[:conditions] = {:name.like => "%#{search_request['search']}%"}
              end
            end
          
            page_size = 20
            page = [params[:page].to_i, 1].max

            data, total = SystemConfiguration::Variable.all_and_count(
                query_options.merge({:offset => (page - 1)  * page_size, :limit => page_size}) )

            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Create a new variable
        #
        app.post "/api/variable", :allowed_usergroups => ['staff','webmaster'] do
          request.body.rewind
          variable_request = JSON.parse(URI.unescape(request.body.read))
          
          the_variable = SystemConfiguration::Variable.create(variable_request) 
                    
          status 200
          content_type :json
          the_variable.to_json                  
        end
        
        #
        # Updates a variable
        #
        app.put "/api/variable", :allowed_usergroups => ['staff','webmaster'] do
          request.body.rewind
          variable_request = JSON.parse(URI.unescape(request.body.read))
          
          if the_variable = SystemConfiguration::Variable.get(variable_request['name'])
            the_variable.attributes=(variable_request)
            the_variable.save
          else
            the_variable = SystemConfiguration::Variable.create(variable_request)
          end    

          status 200
          content_type :json
          the_variable.to_json
        end
        
        #
        # Updates multiple variables
        #
        app.put "/api/variables", :allowed_usergroups => ['staff','webmaster'] do
      
          request.body.rewind
          variables = JSON.parse(URI.unescape(request.body.read))      
          
          variables.each do |key, value|
            variable = SystemConfiguration::Variable.get(key)
            variable ||= SystemConfiguration::Variable.new()
            if value.is_a?Array
              if value.all? {|x| !!x == x}
                value = value.last
              end
            end
            variable.value = value
            variable.save                     
          end
          
          content_type :json
          true.to_json
      
        end

        #
        # Deletes a variable
        #
        app.delete "/api/variable", :allowed_usergroups => ['staff','webmaster'] do
          request.body.rewind
          variable_request = JSON.parse(URI.unescape(request.body.read))

          if the_variable = SystemConfiguration::Variable.get(variable_request['name'])
            the_variable.destroy
            status 200
            content_type :json
            body true.to_json
          else
            status 404 
          end

        end
      
      end
    
    end #VariableManagementRESTApi
  end #YSD
end #Sinatra