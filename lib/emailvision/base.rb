module DriesS
  module Emailvision

    if defined?(Rails)
      class Engine < Rails::Engine; end
    end

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods

      def acts_as_emailvision_subscriber(opts={}, &block)

        class_attribute :email_column
        self.email_column =  opts[:email] || 'email'

        class_attribute :confirmed_column
        self.confirmed_column = opts[:confirmed]

        class_attribute :emailvision_enabled_column
        self.emailvision_enabled_column = opts[:enabled]

        class_attribute :emailvision_merge_vars
        self.emailvision_merge_vars = MergeVars.new(&block) if opts[:peform_block]

        self.send(:include, EmailvisionSubscriber)
      end

    end
  end
end