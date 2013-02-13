require 'emailvision'

require 'acts_as_emailvision/merge_vars'
require 'acts_as_emailvision/base'
require 'acts_as_emailvision/acts/emailvision_subscriber'

  
if defined?(Rails)
  require 'acts_as_emailvision/railtie'
end

::Emailvision::Tools.class_eval do 
  
  def self.date_time_format(datetime)
    datetime.strftime('%m/%d/%Y')
  end

  def self.date_format(datetime)
    datetime.strftime('%m/%d/%Y')
  end

  def self.date_format_unsubscribe(datetime)
    datetime.strftime('%m/%d/%Y')
  end

end

ActiveRecord::Base.send(:include, DriesS::ActsAsEmailvision) # trigger included method in emailvision_subscriber.rb