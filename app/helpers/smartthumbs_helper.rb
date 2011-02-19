module SmartthumbsHelper
  
  def thumb_tag(record, format, opts={})
    image_tag record.thumb_url_for(format), opts
  end
    
end