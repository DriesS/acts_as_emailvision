require 'helper'
require 'test/unit'
require 'logger'
require 'pry'
require 'date'

require File.expand_path(File.dirname(__FILE__) + '/../rails/init')

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

class TestActsAsEmailvision < Test::Unit::TestCase
  
  def setup_test_models
    load(File.expand_path(File.dirname(__FILE__) + '/models.rb'))
  end

  def setup_users
    require File.expand_path(File.dirname(__FILE__) + '/generators/create_user') 
    CreateUsers.up
    @user = User.create(:email => "emailvision@axonet.be", :wants_email => false)
  end

  def setup_config
    file = File.expand_path(File.dirname(__FILE__) + '/../lib/generators/acts_as_emailvision_config/templates/emailvision.yml')

    if File.exist?(file)
      config = YAML.load_file(file)["test"] || {}

      DriesS::Emailvision::Api.server_name  = config['server_name']
      DriesS::Emailvision::Api.endpoint     = config['endpoint']
      DriesS::Emailvision::Api.login        = config['login']
      DriesS::Emailvision::Api.password     = config['password']
      DriesS::Emailvision::Api.key          = config['key']       
      DriesS::Emailvision::Api.debug        = config['debug']       

    end     
  end

  def setup
    setup_config
    setup_test_models
    setup_users
  end

  def teardown
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end

  def test_subscribe_user
    @user.wants_email = true
    @user.save
  end

end
