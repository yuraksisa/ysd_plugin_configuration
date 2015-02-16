module Sinatra
  module YSD
  	#
  	# Sinatra extension to manage SystemConfiguration::SecureVariable
  	#
  	module SecureVariableManagement
      def self.registered(app)
        
        app.get '/admin/configuration/svariable' do

          load_page :secure_variable_management, 
            :locals => {:secure_variable_page_size => 10}

        end

      end
  	end
  end
end