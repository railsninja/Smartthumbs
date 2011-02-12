module Smartthumbs

  module Thumbable
    require 'RMagick'
    include Magick

    # return the rmagick instance
    def rmagick_img
      if self.class.st_config[:blob].present?
        @rmagick_img ||= Magick::ImageList.new.from_blob(
          self.send(self.class.st_config[:blob])
        ).first
      elsif self.class.st_config[:file].present?
        @rmagick_img ||= Magick::ImageList.new.from_blob(
          File.read(self.send(self.class.st_config[:file]))
        ).first
      else
        raise "No thumb source defined. You have to define neither :blob or :file"
      end
    end

    # returns all possible @formats for the current image 
    def st_format(f)
      self.class.st_config[:formats][f]
    end
    
    # returns the file extension for the current image
    def st_extension
      "jpg"
    end

    # creates the directory for a certain @format if it doesn't exist
    def create_directory
      dest = File.dirname(thumb_path_for(@format))
      FileUtils.mkdir_p(dest) unless File.exists?(dest)
    end

    # Creates the thumb for a certain @format
    def create_thumb_for(format)
      @format = format
      return if st_format(@format).blank?
      
      create_directory
      
      method = st_format(@format)[1] || :cut
      @x, @y = st_format(@format).first.split("x").map(&:to_i)

      if self.respond_to?(method)
        self.send(method) 
      end
      
      rounding_error
      rmagick_img.write(thumb_path_for(@format)) { self.quality = 80 }
      nil
    end

    # returns the gravity for the current resizing process and
    # provides some shrotcuts
    def gravity
      return Magick::CenterGravity unless (st_format(@format) || []).length >= 3
      {
        :new => Magick::NorthWestGravity,
        :n =>   Magick::NorthGravity,
        :ne =>  Magick::NorthEastGravity,
        :w =>   Magick::WestGravity,
        :c =>   Magick::CenterGravity,
        :e =>   Magick::EastGravity,
        :sw =>  Magick::SouthWestGravity,
        :s =>   Magick::SouthGravity,
        :se =>  Magick::SouthEastGravity
      }[st_format(@format).last]
    end

    # Does a thumb already exist?
    def thumb_exists_for?(format)
      File.exists?(self.thumb_path_for(format))
    end

    # returns the cache-path for a certain image
    def thumb_path_for(format)
      "#{Rails.root}/public#{thumb_url_for(format)}"
    end

    # return the http url to the resized image
    def thumb_url_for(format)
      "/th/#{self.class.to_s.underscore.parameterize}/#{format.to_s}/#{self.id}.#{st_extension}"
    end

    # resizes the image in a manner that both edges fit the needs.
    # usually one of the edges is smaller than the needs afterwards
    def fit
      if self.needs_to_be_resized?
        rmagick_img.resize_to_fit!(@x, @y)
      else
        rmagick_img.resize_to_fit(@x, @y)
      end
    end

    # the same as +fit+, except the fact that the image
    # get's filled up with a border
    def fill
      fit
      rounding_error
      border_x = (@x - rmagick_img.columns)/2
      border_y = (@y - rmagick_img.rows)/2

      rmagick_img.border!(border_x,border_y,"white")
    end

    # resizes and cuts the image, so it that it fits exactly
    def cut
      rmagick_img.crop_resized!(@x, @y, gravity)
    end

    # if there's just a small difference between the needs and the result,
    # we'll make it fit exaclty
    def rounding_error
      dif = (@y-rmagick_img.rows) + (@x-rmagick_img.columns)

      if dif > 0 && dif < 10 then
        rmagick_img.resize!(@x, @y)
      end
    end

    # checks whether the image needs to be resized to fit the current @format or not
    def needs_to_be_resized?
      rmagick_img.rows > @y || rmagick_img.columns > @x
    end
  end
end