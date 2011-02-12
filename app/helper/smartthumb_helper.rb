module SmartthumbHelper
  
  def thumb_tag(record, foramt, opts={})
    image_tag record.thumb_url_for(format), opts
  end
    
end