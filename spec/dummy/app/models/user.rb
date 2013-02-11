class User < ActiveRecord::Base
  acts_as_emailvision_subscriber({:enabled => :wants_email, :confirmed => :confirmed})

  attr_accessible :confirmed, :wants_email, :email
end