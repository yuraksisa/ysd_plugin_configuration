module Sinatra
  module YSD
    module VariableManagement
   
      def self.registered(app)
            
        #
        # Variables management page
        #
        app.get "/admin/configuration/variable" do
          load_em_page :variable_management, nil, false,
            :locals => {:variable_page_size => 20}
        end
              
      end
    
    end #VariableManagement
  end #YSD
end #Sinatra