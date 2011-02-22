## Smartthumbs

This Gem helps you create any kind of thumbnails on-the-fly.

## Features
* define your various thumb-formats inside of your model and let smartthumbs do the rest.
* writes created thumbs to the public directory - every thumb is only created once and only if needed
* Works with blob-based records and filename-based records
* can be implemented in several models
* define which strategy should be used to resize your images

## Install
Add the Gem to your Gemfile:

    gem "smartthumbs"

and run 

    bundle install


Afterwards you should create an initializer-script in config/initializers:

    Smartthumbs::Config.run do |config|
      config[:valid_classes] = ["Image"]
      
      config[:assume_klass] = "Image" # optional
    end

Smartthumbs needs to know all classes that you want to use smartthumbs with.
Pass them as an array of strings via :valid_classes .

By default smartthumbs generates urls like "/th/<klass-name>/<format>/<record-id>.<extension>". If you only have a single class you can set the default-class and prevent this class name from appering in that url. 

That's it, your ready to use smartthumbs.

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
	  smartthumbs :blob => :db_blob_column, :extension => :my_extension, :formats => {
	   "thumb" => ["800x100", :fit, :e]
	  }
    
	  def my_extension
	    "jpg"
	  end
	end

### In your View

    <%= thumb_tag, @image, "tiny", :class => "red-border" %>

will generate something like:

    <img src="/th/my_image/tiny/5.jpg" class="red-border"/>


Copyright (c) 2011 Alexander Pauly, released under the MIT license
