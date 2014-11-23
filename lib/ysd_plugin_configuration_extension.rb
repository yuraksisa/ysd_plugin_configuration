require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener

#
# Configuration Extension
#
module Huasi

  class ConfigurationExtension < Plugins::ViewListener
 
    # ========= Installation =================

    # 
    # Install the plugin
    #
    def install(context={})

       SystemConfiguration::Variable.first_or_create({:name => 'configuration.variables_page_size'}, 
                                                     {:value => '20', :description => 'configuration page size', :module => :configuration}) 

    
    end 
                
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
                                  :link_route => "/admin/configuration/variable",
                                  :description => 'Configure modules settings',
                                  :module => 'configuration',
                                  :weight => 10}},
                    {:path => '/configuration/settings',
                     :options => {:title => app.t.configuration_admin_menu.secure_variable_management,
                                  :link_route => "/admin/configuration/svariable",
                                  :description => 'Configure modules secure settings',
                                  :module => 'configuration',
                                  :weight => 12}},
                                ]
       
   
    end
  
  
    # ========= Routes ===================
    
    # routes
    #
    # Define the module routes, that is the url that allow to access the funcionality defined in the module
    #
    #
    def routes(context={})
    
      routes = [{:path => '/admin/configuration/variable',
                 :regular_expression => /^\/admin\/configuration\/variable/,
                 :title => 'Settings',
                 :description => 'Configure modules settings',
                 :fit => 1,
                 :module => :configuration},
                {:path => '/admin/configuration/svariable',
                 :regular_expression => /^\/admin\/configuration\/svariable/,
                 :title => 'Settings',
                 :description => 'Configure modules secure settings',
                 :fit => 1,
                 :module => :configuration}
               ]
    
    end  
  
  end #ConfigurationExtension
end #Huasi