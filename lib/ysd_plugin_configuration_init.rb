require 'ysd-plugins' unless defined?Plugins::Plugin
require 'ysd_plugin_configuration_middleware'
require 'ysd_plugin_configuration_extension'

Plugins::SinatraAppPlugin.register :configuration do

   name=        'configuration'
   author=      'yurak sisa'
   description= 'Integrate the configuration'
   version=     '0.1'
   sinatra_extension Sinatra::YSD::Configuration
   sinatra_extension Sinatra::YSD::VariableManagement
   sinatra_extension Sinatra::YSD::VariableManagementRESTApi
   hooker            Huasi::ConfigurationExtension
  
end