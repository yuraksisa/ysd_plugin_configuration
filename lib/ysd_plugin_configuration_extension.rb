require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener

#
# Configuration Extension
#
module Huasi

  class ConfigurationExtension < Plugins::ViewListener
                
    # ========= Menu =====================
    
    #
    # It defines the admin menu menu items
    #
    # @return [Array]
    #  Menu definition
    #
    def menu(context={})
      
      app = context[:app]
       
      menu_items = [{:path => '/configuration',
                     :options => {:title => app.t.configuration_admin_menu.configuration_menu,
                                  :description => 'Configures the modules', 
                                  :module => 'configuration',
                                  :weight => 8}},
                    {:path => '/configuration/settings',
                     :options => {:title => app.t.configuration_admin_menu.variable_management,
                                  :link_route => "/variable-management",
                                  :description => 'Configure the modules settings',
                                  :module => 'configuration',
                                  :weight => 10}}]
       
   
    end
  
  
    # ========= Routes ===================
    
    # routes
    #
    # Define the module routes, that is the url that allow to access the funcionality defined in the module
    #
    #
    def routes(context={})
    
      routes = [{:path => '/variable-management',
                 :regular_expression => /^\/variable-management/,
                 :title => 'Settings',
                 :description => 'Configure the modules settings',
                 :fit => 1,
                 :module => :configuration}]
    
    end  
  
  end #ConfigurationExtension
end #Huasi