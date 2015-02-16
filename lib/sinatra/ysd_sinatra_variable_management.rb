module Sinatra
  module YSD
    module VariableManagement
   
      def self.registered(app)
            
        #
        # Variables management page
        #
        app.get "/admin/configuration/variable" do
          load_page :variable_management, 
            :locals => {:variable_page_size => 12}
        end
              
      end
    
    end #VariableManagement
  end #YSD
end #Sinatra