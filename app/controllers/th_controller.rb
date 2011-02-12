class ThController < ApplicationController
  
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
    parsed[0] = parsed.first.gsub("-", "/").classify.constantize
    parsed
  end
  
end