require 'ysd_md_integration'
module Sinatra
  module YSD
    module VariableManagement
   
      def self.registered(app)
            
        #
        # Variables management page
        #
        app.get "/variable-management" do
          load_page 'variable_management'.to_sym
        end
              
      end
    
    end #VariableManagement
  end #YSD
end #Sinatra