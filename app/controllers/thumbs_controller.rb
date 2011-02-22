class ThumbsController < ApplicationController
  
  require 'RMagick'
  include Magick

  def deliver_crop
    klass, format, id = parse_params
    
    @obj = klass.find(id)
    @obj.create_thumb_for(format)

    send_file(@obj.thumb_path_for(format), :type => 'image/jpeg', :disposition => 'inline')
  end

private
  def parse_params
    parsed = params[:path].split(".")[0..-2].first.split("/")
    
    if parsed.length < 3 &&  Smartthumbs::Config.options[:assume_klass].present?
      parsed.unshift(
        Smartthumbs::Config.options[:assume_klass]
      )
    else
      parsed[0] = parsed.first.gsub("-", "/").classify  
    end
    
    unless Smartthumbs::Config.options[:valid_classes].include?(parsed[0])
      raise "Bad Request"
    else
      parsed[0] = parsed.first.constantize
    end
    parsed
  end
  
end