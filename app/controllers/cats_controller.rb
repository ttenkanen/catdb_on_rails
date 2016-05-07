class CatsController < ApplicationController
  
  http_basic_authenticate_with name: "catdb", password: "password"
  
  before_action :set_s3_direct_post, only: [:new, :destroy, :create, :index, :edit, :update]
    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
    end
  
  # list our cats
  def index
    @cats = Cat.all
    #TODO pictures are now fetched in view, move here?
  end

  # show data for one cat
  def show
    @cat = Cat.find(params[:id])
    @pictures = Picture.where("title LIKE '"+@cat.id.to_s+"'")
  end

  # print a form to add another cat
  def new
    @cat = Cat.new
  end

  # insert form data into our database
  def create
    @cat = Cat.new(catparams)
    if @cat.save
      redirect_to @cat
    else
      render 'new'
    end
  end

  # print a form to edit one of our cats
  def edit
    @cat = Cat.find(params[:id])
    @picture = Picture.new
    @pictures = Picture.where("title LIKE '"+@cat.id.to_s+"'")
  end
  
  # update form data into the database
  def update
    @cat = Cat.find(params[:id])
    if @cat.update(catparams)
      redirect_to @cat
    else
      render 'edit'
    end
  end
  
  # delete a cat from the database
  def destroy
    @cat = Cat.find(params[:id])
    #TODO @pictures = Picture.where("title LIKE '"+@cat.id.to_s+"'")
    #TODO: call @picture.destroy for each @pictures..
    @cat.destroy

    redirect_to cats_path
  end

  # required params for save,update
  private 
  def catparams
    params.require(:cat).permit(:name, :color, :race, :gender)
  end

end
