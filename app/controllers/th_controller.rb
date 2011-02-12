class ThController < ApplicationController
  
  require 'RMagick'
  include Magick
  
  def deliver_crop
    render :text => params.inspect and return
    begin
      @obj = Obj.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      send_file("#{RAILS_ROOT}/public/images/noz/empty.png", :type => 'image/png', :disposition => 'inline') and return
    end

    @format = params[:format]

    deliver_file and return if @format == "full"

    if @format == "ressort" || @format == "ressortlarge" || @format == "ressort_blue" then
      isLarge = true
      color = nil
      color = "blue" if @format == "ressort_blue"
      isLarge = nil unless @format == "ressortlarge"
      ressortPic = RessortPicsController.new(@obj, {:large => isLarge, :color => color})
      ressortPic.index

      pathToThumb    = "#{RAILS_ROOT}/public/th/#{@format}/#{@obj.id}.gif"

      send_file(pathToThumb, :type => 'image/jpeg', :disposition => 'inline') and return
      #          redirect_to ressort_url(:name=> @obj.id.to_s, :title=>@obj.title.to_s)
      return
    end

    @obj.create_thumb_for(@format)

    if @obj.file_extension == "png"
      send_file(@obj.thumb_path_for(@format), :type => 'image/png', :disposition => 'inline')
    else
      send_file(@obj.thumb_path_for(@format), :type => 'image/jpeg', :disposition => 'inline')
    end
  end
  
end