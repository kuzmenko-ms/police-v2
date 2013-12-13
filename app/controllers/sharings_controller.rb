class SharingsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :new, :klim]
  
def search
    @departments = Department.all
    @data = Sharing.all.find_all{|x| x.departement == params[:departement]}
    puts ">>>>>>", params[:departement], @data.size
    respond_to do |format|
      format.js   {}
      format.json {  }
    end
  end
  def index
@departments = Department.all
    @sharings = Sharing.all(:order => "created_at desc")
    @sharing = Sharing.new
  end

  def show
    @departments = Department.all	
    @sharing = Sharing.find(params[:id])
  end

  def new
    @departments = Department.all
    @sharing = Sharing.new
  end

  def create
    @sharing = current_user.sharings.build(params[:sharing])

    if @sharing.save
      if current_user
        current_user.tweet!(@sharing.content) if current_user.connected_to?(:twitter)
        current_user.fb_post!(@sharing.content) if current_user.connected_to?(:facebook)
      end

      redirect_to(:action => "index", :notice => 'Sharing was successfully created.')
    else
      @sharings = Sharing.all(:order => "created_at desc")
      render :action => "new"
    end
  end

def klim
    @sharing = current_user.sharings.find(params[:id])
    @sharing.destroy
   redirect_to(root_path)
    
  end

end

