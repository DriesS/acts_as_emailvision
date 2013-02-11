require 'rest_client'
require 'active_support'
require 'active_record'

module DriesS
  module ActsAsEmailvision
    module EmailvisionSubscriber
      
      class EmailVisionConfigError < StandardError; end
      class EmailVisionConnectError < StandardError; end

      begin
        Object.send(:include, Delayed::MessageSending)
        Module.send(:include, Delayed::MessageSending::ClassMethods)
      rescue
        puts "Could not load delayed job"
      end

      def self.included(base)

        base.extend ClassMethods

        mattr_reader :emv_config

        base.instance_eval do
          after_create :after_emailvision_subscriber_create, :if => :is_confirmed?
          after_update :before_emailvision_subscriber_update, :if => :is_confirmed?
          after_destroy :after_emailvision_subscriber_destroy, :if => :is_confirmed?
        end

      end

      module ClassMethods

        def emv_config
          @@emv_config = YAML.load(File.open("#{Rails.root}/config/emailvision.yml"))[Rails.env.to_s].symbolize_keys
        end

      end

      def is_confirmed?
        self.send(self.confirmed_column.to_sym)
      end

      
      def to_emv(opts={})

        merge_vars = Array.new

        self.emailvision_merge_vars.each{ |key|
          merge_vars << {:key => key.to_s.upcase, :value => emailvision_merge_var(key)} unless emailvision_merge_var(key).nil?
        }

        body = {
          :synchro_member => {
            :dyn_content => {
              :entry => merge_vars
            }, 
            :email => self[email_column]
          }
        }

        return body

      end

      def emailvision_merge_var(key)
        value = self.emailvision_merge_vars[key]
        if value.is_a? Symbol
          self.send(value)
        else
          return value
        end
      end

      def emailvision_merge_var_changed?(key)
        value = self.emailvision_merge_vars[key]
        if value.is_a? Symbol
          self.respond_to?("#{value}_changed?") && self.send("#{value}_changed?")
        else
          return false
        end
      end

      def merge_vars_changed?
        changed = false
        self.emailvision_merge_vars.each { |mv|
          changed ||= emailvision_merge_var_changed?(mv) unless emailvision_merge_var(mv).nil?
        }
        return changed
      end

      def after_emailvision_subscriber_create
        wants_email = self.send(self.emailvision_enabled_column.to_sym)
        if wants_email
          self.subscribe_or_update_emailvision
        end
      end

      def before_emailvision_subscriber_update
      
        wants_email = self.send(self.emailvision_enabled_column.to_sym)
        wants_email_changed = self.send((self.emailvision_enabled_column.to_s + "_changed?").to_sym)

        if wants_email_changed
          if wants_email
            self.subscribe_or_update_emailvision_with_delay
          else
            old_email = self.send("#{self.email_column}_was") || self.send("#{self.email_column}")
            self.unsubscribe_emailvision(old_email)
          end
        elsif wants_email
          email_changed = self.send("#{self.email_column}_changed?")
          confirmed_changed = self.send("#{self.confirmed_column}_changed?")
          if email_changed || merge_vars_changed? || confirmed_changed
            old_email = self.send("#{self.email_column}_was") || self.send("#{self.email_column}")
            if confirmed_changed
              self.subscribe_or_update_emailvision(old_email)
            else
              self.subscribe_or_update_emailvision_with_delay(old_email)
            end
          end
        end
      end

      def after_emailvision_subscriber_destroy
        self.unsubscribe_emailvision
      end

      def subscribe_or_update_emailvision(email = self[email_column])
        @@emvAPI ||= ::Emailvision::Api.new
        @@emvAPI.open_connection
        if self.exists_on_emailvision? && !self.is_subscribed_on_emailvision?
          @@emvAPI.get.member.rejoinByEmail(:email => email).call
          self.send_callback(:subscribe, {:email => email})         
        else
          @@emvAPI.post.member.insertOrUpdateMember(:body => self.to_emv).call
          self.send_callback(:subscribe, {:email => email})
        end
      end
      
      def unsubscribe_emailvision(email = self[email_column])
        @@emvAPI ||= ::Emailvision::Api.new
        @@emvAPI.open_connection
        @@emvAPI.get.member.unjoinByEmail(:email => email).call
        self.send_callback(:unsubscribe, {:email => email})
      end

      def subscribe_or_update_emailvision_with_delay(email = self[email_column])
        @@emvAPI ||= ::Emailvision::Api.new
        @@emvAPI.open_connection
        if self.exists_on_emailvision? && !self.is_subscribed_on_emailvision?
          @@emvAPI.get.member.rejoinByEmail(:email => email).call
          self.send_callback(:subscribe, {:email => email})         
        else
          @@emvAPI.post.member.insertOrUpdateMember(:body => self.to_emv).call
          self.send_callback(:subscribe, {:email => email})
        end
      end

      def exists_on_emailvision?
        @@emvAPI ||= ::Emailvision::Api.new
        @@emvAPI.open_connection
        return_object = @@emvAPI.get.member.getMemberByEmail(:email => self[email_column]).call
        if return_object
          !return_object["members"].nil?
        else
          false
        end
      end

      def is_subscribed_on_emailvision?
        @@emvAPI ||= ::Emailvision::Api.new
        @@emvAPI.open_connection
        return_object = @@emvAPI.get.member.getMemberByEmail(:email => self[email_column]).call

        if return_object && return_object["members"]
          members = return_object["members"]["member"]
          return members["attributes"]["entry"].find {|h|h["key"]=='DATEUNJOIN'}['value'].nil?
        else
          return false
        end

      end

      def send_callback(method, params = {})
        if self.class.emv_config[:callback_url]
          sleep 2
          begin
            @result = HTTParty.post(self.class.emv_config[:callback_url].to_str,
              :body => {
                :data => {:email => params[:email]}, :type => method, :token => Digest::SHA1.hexdigest("#{params[:email]}-#{self.class.emv_config[:callback_token]}")
              }.to_json,
              :headers => { 'Content-Type' => 'application/json' }
            )
          rescue Errno::ETIMEDOUT => e
            #do nothing, drop callback
          rescue Exception => e
            raise e
          end
        end
      end
      
      if defined?(Delayed::MessageSending) && !Rails.env.test?
        handle_asynchronously :subscribe_or_update_emailvision
        handle_asynchronously :unsubscribe_emailvision
        handle_asynchronously :subscribe_or_update_emailvision_with_delay, :run_at => Proc.new { 2.minutes.from_now }
      end
        
    end
  end
end 