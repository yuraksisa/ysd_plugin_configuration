require 'ysd_md_configuration' unless defined?SystemConfiguration::SecureVariable
module Sinatra
  module YSD
    #
    # REST API to manage SystemConfiguration::SecureVariable
    #
    module SecureVariableManagementRESTApi

      def self.registered(app)
   
        ['/svariables','/svariables/page/:page'].each do |path|
          app.post path do
            
            query_options = {}
            
            if request.media_type == "application/x-www-form-urlencoded"
              if params[:search]
                query_options[:conditions] = {:name.like => "%#{params[:search]}%"} 
              else
                request.body.rewind
                search_text=request.body.read
                query_options[:conditions] = {:name.like => "%#{search_text}%"} 
              end
            end

            page_size = SystemConfiguration::Variable.
              get_value('configuration.secure_variable_page_size', 20).to_i 
  
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
        app.post '/svariable' do
        
          s_variable_request = body_as_json(SystemConfiguration::SecureVariable)
          secure_variable = SystemConfiguration::SecureVariable.create(s_variable_request)

          status 200
          content_type :json
          secure_variable.to_json

        end
        
        #
        # Updates a secure variable
        #
        app.put '/svariable' do

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
        # Delete a secure variable
        #
        app.delete '/svariable' do

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