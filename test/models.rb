class User < ActiveRecord::Base
  acts_as_emailvision_subscriber({:enabled => :wants_email})
end