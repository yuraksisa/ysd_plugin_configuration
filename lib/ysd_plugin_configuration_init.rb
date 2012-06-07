require 'ysd-plugins' unless defined?Plugins::Plugin
require 'ysd_plugin_configuration_middleware'
require 'ysd_plugin_configuration_extension'

Plugins::SinatraAppPlugin.register :configuration do

   name=        'configuration'
   author=      'yurak sisa'
   description= 'Integrate the configuration'
   version=     '0.1'
   sinatra_extension Sinatra::Configuration
   sinatra_extension Sinatra::YSD::VariableManagement
   hooker            Huasi::ConfigurationExtension
  
end