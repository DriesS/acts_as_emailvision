require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ruby-debug'


describe DriesS::ActsAsEmailvision::EmailvisionSubscriber do
  
  describe :initialize do
    
    it "Emailvision config should not be empty" do
      Emailvision::Api.server_name.should_not be_blank
      Emailvision::Api.login.should_not be_blank
      Emailvision::Api.endpoint.should_not be_blank
      User.emailvision_enabled_column.should_not be_blank
      User.confirmed_column.should_not be_blank
      User.email_column.should_not be_blank
    end
  end


  describe :update do
    
    before(:each) do

    end
  
    it "should call after_emailvision_subscriber_create when user is created" do
      @user = User.new(:confirmed => false, :wants_email => false)
      @user.should_not_receive(:after_emailvision_subscriber_create)
      @user.save
      @user.should_not_receive(:subscribe_or_update_emailvision)
      @user.confirmed = true
      @user.save
    end

    it "should call subscribe_or_update_emailvision" do
      @user = User.new(:confirmed => false, :wants_email => true)
      @user.should_not_receive(:after_emailvision_subscriber_create)
      @user.save
      @user.should_receive(:subscribe_or_update_emailvision)
      @user.confirmed = true
      @user.save
    end

    it "should call unsubscribe_emailvision " do
      @user = User.create(:confirmed => true, :wants_email => true, :email => "dries@test.com")
      @user.should_receive(:unsubscribe_emailvision)
      @user.wants_email = false
      @user.save
    end

    it "should call before_emailvision_subscriber_update when user change to wants emails" do
      @user = User.create(:confirmed => true, :wants_email => false, :email => "dries@test.com")
      @user.should_receive(:subscribe_or_update_emailvision_with_delay)
      @user.wants_email = true
      @user.save
    end

    after do

    end
  end

  describe :destroy do
    it "should unsubsubscribe me when I destroy my account" do
      @user = User.create(:confirmed => true, :wants_email => true, :email => "dries@test.com")
      @user.should_receive(:unsubscribe_emailvision)
      @user.destroy
    end
  end
end