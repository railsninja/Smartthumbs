require 'smartthumbs'
require 'rails'
require 'action_controller'

#http://www.themodestrubyist.com/2010/03/05/rails-3-plugins---part-2---writing-an-engine/

module Smartthumbs
  class Engine < Rails::Engine
    config.to_prepare do
      ApplicationController.helper(SmartthumbHelper)
    end
  end
end
