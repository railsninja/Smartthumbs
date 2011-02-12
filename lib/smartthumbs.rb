module Smartthumbs
  require 'smartthumbs/engine' if defined?(Rails)
  
  module ActiceRecord
    module ClassMethods
      attr_accessor :st_config
      def smartthumbs(opts={})
        self.st_config = opts
        self.send(:include, Smartthumbs::Thumbable)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end  
  end
  
  ::ActiveRecord::Base.send(:include, Smartthumbs::ActiceRecord)
 
end
