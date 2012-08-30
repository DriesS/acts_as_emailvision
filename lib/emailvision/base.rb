module DriesS
  module Emailvision

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods

      def acts_as_emailvision_subscriber(opts={}, &block)

        class_attribute :email_column
        self.email_column =  opts[:email] || 'email'

        class_attribute :emailvision_enabled_column
        self.emailvision_enabled_column = opts[:enabled]

        class_attribute :emailvision_merge_vars
        self.emailvision_merge_vars = MergeVars.new(&block)

        self.send(:include, EmailvisionSubscriber)
      end

    end
  end
end