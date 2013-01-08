Gem::Specification.new do |s|
  s.name    = "ysd_plugin_configuration"
  s.version = "0.1.2"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-05-09"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb','views/**/*.erb','i18n/**/*.yml','static/**/*.*'] 
  s.description = "Configuration integration"
  s.summary = "Configuration integration"
  
  s.add_runtime_dependency "json"  
  
  s.add_runtime_dependency "ysd_md_configuration"        # Model
  s.add_runtime_dependency "ysd_core_plugins"            # Plugin system
  s.add_runtime_dependency "ysd_yito_core"               # Page serving
  
end