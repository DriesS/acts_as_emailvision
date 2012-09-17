require 'rails'

module DriesS
  module Emailvision
    class Railtie < Rails::Railtie
      
      generators do
        require 'generators/acts_as_emailvision_config/acts_as_emailvision_config_generator'
      end   
    
      config.to_prepare do
        file = "#{Rails.root}/config/emailvision.yml"
        
        if File.exist?(file)
          config = YAML.load_file(file)[Rails.env] || {}
          
          Emailvision::Api.server_name  = config['server_name']
          Emailvision::Api.endpoint     = config['endpoint']
          Emailvision::Api.login        = config['login']
          Emailvision::Api.password     = config['password']
          Emailvision::Api.key          = config['key']       
          Emailvision::Api.debug        = config['debug']
          Emailvision::Api.callback_token = config['callback_token']   
          Emailvision::Api.callback_url = config['callback_url']        
          
        end     
      end   
    
    end
  end
end