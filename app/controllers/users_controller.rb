class UsersController < ApplicationController
  
  layout "template"
  
  require 'digest/md5'

  # GET /users
  # GET /users.xml
  def index
    if session[:user_id] == 5
      @users = User.all
           
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
    else
      redirect_to "/bookmarks"
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    if session[:user_id].to_s == params[:id].to_s
      @user = User.find(params[:id])
      if @user.background.include?("http")
        
      else
        @user.background = Rails.root + '/data/' + @user.background 
      end
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    else
      redirect_to "/users/show/" + session[:user_id].to_s
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    if session[:user_id].to_s == params[:id].to_s
      @user = User.find(params[:id])
    else
      redirect_to "/users/edit/" + session[:user_id].to_s
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if @user.password.to_s == ""
      flash[:notice] = "Password is empty."
      redirect_to :action => "new" 
      return
    else
      @user.password = Digest::MD5.hexdigest(@user.password)
       
      if params[:url].to_s.blank?
        imgName = User.save(params[:user])
        @user.background = imgName.to_s
      else
        @user.background = params[:url]
      end
      
      respond_to do |format|
        if @user.save
          format.html { redirect_to("/", :notice => 'User was successfully created.') }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    if session[:user_id].to_s == params[:id].to_s
      @user = User.find(params[:id])
      
      if @user.password != params[:user][:password]
        params[:user][:password] = Digest::MD5.hexdigest(params[:user][:password])
      end
      
      if params[:url].to_s.blank?
        imgName = User.save(params[:user])
        params[:user][:background] = imgName.to_s
      else
        params[:user][:background] = params[:url]
      end
      
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to "/users/edit/" + session[:user_id].to_s
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if session[:user_id].to_s == params[:id].to_s
      @user = User.find(params[:id])
      @user.destroy
  
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      end
    else
      redirect_to "/users/edit/" + session[:user_id].to_s
    end
  end
  
  def login
    
  end
  
  def authenticate
    login = params[:login]
    
    @user = User.new(params[:login])
    @user.password = Digest::MD5.hexdigest(@user.password)
    valid = User.find(:first, :conditions => ["email = ? and password = ?",@user.email, @user.password])
    
    if valid
      session[:user_id] = valid.id
      redirect_to "/bookmarks"
    else
      redirect_to :back
    end
  end
  
  def logout
    session[:user_id] = nil
    redirect_to "/login"
  end
end
