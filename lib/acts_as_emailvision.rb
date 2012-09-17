require 'httparty'
require 'logger'
require 'crack/xml'
require 'builder'

require 'emailvision/api/api'
require 'emailvision/api/exception'
require 'emailvision/api/logger'
require 'emailvision/api/relation'
require 'emailvision/api/tools'
require 'emailvision/merge_vars'
require 'emailvision/base'
require 'emailvision/acts/emailvision_subscriber'

  
if defined?(Rails)
  require 'emailvision/api/railtie'
  require 'emailvision/railtie'
end

ActiveRecord::Base.send(:include, DriesS::Emailvision) # trigger included method in emailvision_subscriber.rb