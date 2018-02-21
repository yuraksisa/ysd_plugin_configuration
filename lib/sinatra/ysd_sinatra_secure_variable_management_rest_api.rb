require 'ysd_md_configuration' unless defined?SystemConfiguration::SecureVariable
module Sinatra
  module YSD
    #
    # REST API to manage SystemConfiguration::SecureVariable
    #
    module SecureVariableManagementRESTApi

      def self.registered(app)
   
        ['/api/svariables','/api/svariables/page/:page'].each do |path|
          app.post path, :allowed_usergroups => ['staff'] do
            
            query_options = {}
            
            if request.media_type == "application/json"
              request.body.rewind
              search_request = JSON.parse(URI.unescape(request.body.read))
              if search_request.has_key?('search')
                query_options[:conditions] = {:name.like => "%#{search_request['search']}%"}
              end
            end

            page_size = 20
  
            page = [params[:page].to_i, 1].max  

            data, total = SystemConfiguration::SecureVariable.all_and_count(
              query_options.merge({:offset => (page - 1)  * page_size, :limit => page_size}) )
            
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json

          end
        end   
        
        #
        # Creates a new secure variable
        #
        app.post '/api/svariable', :allowed_usergroups => ['staff'] do
        
          s_variable_request = body_as_json(SystemConfiguration::SecureVariable)
          secure_variable = SystemConfiguration::SecureVariable.create(s_variable_request)

          status 200
          content_type :json
          secure_variable.to_json

        end
        
        #
        # Updates a secure variable
        #
        app.put '/api/svariable', :allowed_usergroups => ['staff'] do

          s_variable_request = body_as_json(SystemConfiguration::SecureVariable)
          
          variable_name = s_variable_request.delete(:name)

          if (not variable_name.nil?) and (secure_variable = SystemConfiguration::SecureVariable.get(variable_name))
            secure_variable.attributes= s_variable_request
            secure_variable.save
            status 200
            content_type :json
            secure_variable.to_json
          else
            status 404
          end

        end

        #
        # Updates multiple variables
        #
        app.put "/api/svariables", :allowed_usergroups => ['staff'] do
      
          request.body.rewind
          secure_variables = JSON.parse(URI.unescape(request.body.read))      
          
          secure_variables.each do |key, value|
            secure_variable = SystemConfiguration::SecureVariable.get(key)
            secure_variable ||= SystemConfiguration::SecureVariable.new()
            if value.is_a?Array
              if value.all? {|x| !!x == x}
                value = value.last
              end
            end
            secure_variable.value = value
            secure_variable.save                     
          end
          
          content_type :json
          true.to_json
      
        end

        #
        # Delete a secure variable
        #
        app.delete '/api/svariable', :allowed_usergroups => ['staff'] do

          s_variable_request = body_as_json(SystemConfiguration::SecureVariable)
          
          variable_name = s_variable_request.delete(:name)

          if (not variable_name.nil?) and (secure_variable = SystemConfiguration::SecureVariable.get(variable_name))
            secure_variable.destroy
            status 200
            content_type :json
            true.to_json
          else
            status 404
          end

        end

      end

    end #SecureVariableManagementRESTApi
  end #YSD
end #Sinatra