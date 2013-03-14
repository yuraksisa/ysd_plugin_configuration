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
            
            data = SystemConfiguration::SecureVariable.all
            
            content_type :json
            data.to_json

          end
        end   
  
      end

    end
  end
end