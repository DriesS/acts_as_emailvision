require 'emailvision'

require 'acts_as_emailvision/merge_vars'
require 'acts_as_emailvision/base'
require 'acts_as_emailvision/acts/emailvision_subscriber'

  
if defined?(Rails)
  require 'acts_as_emailvision/railtie'
end

ActiveRecord::Base.send(:include, DriesS::ActsAsEmailvision) # trigger included method in emailvision_subscriber.rb