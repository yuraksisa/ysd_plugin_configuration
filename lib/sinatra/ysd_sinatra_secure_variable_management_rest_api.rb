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
              end
            end

            page_size = SystemConfiguration::Variable.
              get_value('configuration.secure_variable_page_size').to_i 
  
            page = [params[:page].to_i, 1].max  

            data = SystemConfiguration::SecureVariable.all(
              query_options.merge({:offset => (page - 1)  * page_size, :limit => page_size}) )
            
            content_type :json
            data.to_json

          end
        end   
  
      end

    end
  end
end