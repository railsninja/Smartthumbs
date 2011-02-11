module Smartthumbs
  require 'smartthumbs/engine' if defined?(Rails) 
  require 'RMagick'
  include Magick

  def create_thumb_for(format)
    return if format.nil?
    thumb_format = ThumbFormat.find_by_name(format.to_s)
    return if thumb_format.blank?
    @x, @y, method = thumb_format.width, thumb_format.height, thumb_format.method.to_sym

    @img = Magick::ImageList.new.from_blob(Obj.find(self.obj_id).body)

    #    createDir(@format)

    return nil if File.exists?(thumb_path_for(format))

    dest = File.dirname(thumb_path_for(format))
    Dir.mkdir(dest) unless File.exists?(dest)

    begin
      method(method).call
    rescue
      return
    end
    roundingError
    @img.write(thumb_path_for(format)) { self.quality = 80 }

    nil
  end

  def create_thumb_from_blob_with_id(format, blob, id)
    return if format.nil?
    thumb_format = ThumbFormat.find_by_name(format.to_s)
    return if thumb_format.blank?
    @x, @y, method = thumb_format.width, thumb_format.height, thumb_format.method.to_sym
    return if method.nil?

    @img = Magick::ImageList.new.from_blob(blob)

    dest = File.dirname(thumb_path_for(format, id))
    Dir.mkdir(dest) unless File.exists?(dest)

    begin
      method(method).call
    rescue
      return
    end
    roundingError
    @img.write(thumb_path_for(format)) { self.quality = 80 }
      nil
    end

    def thumb_exists_for?(format)
      File.exists?(self.thumb_path_for(format))
    end


    def thumb_path_for(format, id = 0)
      if id > 0
        return "#{RAILS_ROOT}/public/th/#{format.to_s}/#{id}.jpg"
      end

      if self.file_extension == "png"
        return "#{RAILS_ROOT}/public/th/#{format.to_s}/#{self.obj_id}.png"
      end

      return "#{RAILS_ROOT}/public/th/#{format.to_s}/#{self.obj_id}.jpg"
    end

    #### def fit
    #### Verkleinert das Bild in der Art, dass beide Seitenlaengen in das neue Format passen
    #### und das Bild nicht beschnitten wird.
    #### Im Normalfall ist hinterher eine der Seitenlaengen kleiner als die Vorgabe
    def fit
        if self.needs_to_be_resized?
          @img.resize_to_fit!(@x, @y)
        else
          @img.resize_to_fit(@x, @y)
        end
    end

    #### def fill
    #### Analog zu +fit+, allerdings wird das Bild mit einem Rahmen aufgefuellt,
    #### bis es den vorgegebenen Seitenlaengen entspricht
    def fill
        fit
        roundingError
        borderX = (@x - @img.columns)/2
        borderY = (@y - @img.rows)/2

        @img.border!(borderX,borderY,"white")

    end

    #### def cut
    #### Verkleinert und zerschneidet das Bild,
    #### sodass es exakt den Vorgaben entspricht
    def cut
        @img.crop_resized!(@x, @y, Magick::NorthGravity)
    end

    #### def cut_bottom_gravity
    #### Verkleinert und zerschneidet das Bild,
    #### sodass es exakt den Vorgaben entspricht
    def cut_bottom_gravity
        @img.crop_resized!(@x, @y, Magick::SouthGravity)
    end

    #### def cut_bottom_gravity
    #### Verkleinert und zerschneidet das Bild,
    #### sodass es exakt den Vorgaben entspricht
    def cut_center_gravity
        @img.crop_resized!(@x, @y, Magick::CenterGravity)
    end


    #### def roundingError
    #### Falls lediglich eine kleine Differenz zwischen Vorgabe und Ergebnis ist,
    #### wird das Bild exakt auf die gewuenschte Groesse gebracht
    def roundingError
       dif = (@y-@img.rows) + (@x-@img.columns)

       if dif > 0 && dif < 10 then
        @img.resize!(@x, @y)
       end
    end

    def needs_to_be_resized?
      @img.rows > @y || @img.columns > @x
    end

  end