## Smartthumbs

This Gem helps you create any kind of thumbnails on-the-fly.

## Features
* define your various thumb-formats inside of your model and let smartthumbs do the rest.
* writes created thumbs to the public directory - every thumb is only created once and only if needed
* Works with blob-based records and filename-based records
* can be implemented in several models
* define which strategy should be used to resize your images

## Examples

### In your models
class Image < ActiveRecord::Base
	smartthumbs :file => :file_path, :extension => "jpg", :formats => {
	  "thumb" => ["800x200", :cut, :w],
		"small" => ["100x100", :fit],
		"tiny" => ["15x15", :fill]
	}

  def file_path
    "#{Rails.root}/tmp/uploads/#{self.id}.jpg"
  end
end  

class Image < ActiveRecord::Base  
  smartthumbs :blob => :db_blob_column_, :extension => :my_extension, :formats => {
   "thumb" => ["800x100", :fit, :e]
  }
    
  def my_extension
    "jpg"
  end
end

### In your View
<%= thumb_tag, @image, "tiny", :class => "red-border" %>


Copyright (c) 2011 Alexander Pauly, released under the MIT license
