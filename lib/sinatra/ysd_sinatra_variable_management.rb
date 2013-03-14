module Sinatra
  module YSD
    module VariableManagement
   
      def self.registered(app)
            
        #
        # Variables management page
        #
        app.get "/variable-management" do
          load_page :variable_management, 
            :locals => {:secure_variable_page_size => 20}
        end
              
      end
    
    end #VariableManagement
  end #YSD
end #Sinatra