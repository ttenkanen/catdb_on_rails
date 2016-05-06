class PicturesController < ApplicationController
  
  def index
    @pictures = Picture.all
  end
  
  def new
    @picture = Picture.new
  end
  
  def create    
    @picture = Picture.new(picparams)
    #render plain: params[:picture]
    
    ts = Time.now.utc.strftime("%Y%m%d%H%M%S.jpg")
    uploaded_io = params[:picture][:picture]
    filepath = Rails.root.join('app', 'assets', 'images', ts)
    tfilepath = Rails.root.join('app', 'assets', 'images', "t"+ts)
    bfilepath = Rails.root.join('app', 'assets', 'images', "b"+ts)
    #filepath = Rails.root.join('public', 'assets', 'images', ts)
    #tfilepath = Rails.root.join('public', 'assets', 'images', "t"+ts)
    #bfilepath = Rails.root.join('public', 'assets', 'images', "b"+ts)
    File.open(filepath, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    system("convert "+filepath.to_s+" -resize 100x100 "+tfilepath.to_s)
    system("convert "+filepath.to_s+" -resize 400x400 "+bfilepath.to_s)
    @picture.filename = ts
    @picture.save
    redirect_to :back    
  end

  # delete a cat from the database
  def destroy
    @picture = Picture.find(params[:id])
    filepath = Rails.root.join('app', 'assets', 'images', ""+@picture.filename)
    tfilepath = Rails.root.join('app', 'assets', 'images', "t"+@picture.filename)
    bfilepath = Rails.root.join('app', 'assets', 'images', "b"+@picture.filename)
    #filepath = Rails.root.join('public', 'assets', 'images', ""+@picture.filename)
    #tfilepath = Rails.root.join('public', 'assets', 'images', "t"+@picture.filename)
    #bfilepath = Rails.root.join('public', 'assets', 'images', "b"+@picture.filename)
    File.delete(filepath)
    File.delete(tfilepath)
    File.delete(bfilepath)
    @picture.destroy
    redirect_to :back
  end
  
  
  private
  def picparams
    params.require(:picture).permit(:title)
  end
  
end
