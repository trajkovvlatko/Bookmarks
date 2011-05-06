class BookmarksController < ApplicationController
  
  layout "template"
  
  # GET /bookmarks
  # GET /bookmarks.xml
  def index
    if session[:user_id]
      @bookmarks = Bookmark.all(:conditions => "user_id = "+session[:user_id].to_s)
      user = User.find(session[:user_id])
      
      @background = Rails.root + '/data/' + user.background
      
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @bookmarks }
      end
    else
      redirect_to "/login"
    end
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.xml
  def show
    if session[:user_id]
      @bookmark = Bookmark.first(:conditions => "id = " + params[:id].to_s + " AND user_id = " + session[:user_id].to_s)
      if @bookmark
        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @bookmark }
        end
      else
        redirect_to "/bookmarks/"
      end
    else
      redirect_to "/login"
    end
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.xml
  def new
    if session[:user_id]
      @bookmark = Bookmark.new
      @tags = Tag.all
      @checked = Array.new
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @bookmark }
      end
    else
      redirect_to "/login"
    end
  end

  # GET /bookmarks/1/edit
  def edit
    if session[:user_id]
      @bookmark = Bookmark.first(:conditions => {:id => params[:id], :user_id => session[:user_id]})
      if @bookmark
        @tags = Tag.all
        @checked = Array.new
        @bookmark.tags.each do |t|
          @checked.push t.id
        end
      else
          redirect_to "/bookmarks/"
      end
    else
      redirect_to "/login"
    end
  end

  # POST /bookmarks
  # POST /bookmarks.xml
  def create
    if session[:user_id]
      user = User.find(session[:user_id])
      params[:bookmark][:user] = user
      @bookmark = Bookmark.new(params[:bookmark])
      @tags = params[:tag]
      @tags.each do |tag|
        objTag = Tag.find(tag)
        @bookmark.tags << objTag
      end
      respond_to do |format|
        if @bookmark.save
          format.html { redirect_to(@bookmark, :notice => 'Bookmark was successfully created.') }
          format.xml  { render :xml => @bookmark, :status => :created, :location => @bookmark }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @bookmark.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to "/login"
    end
  end

  # PUT /bookmarks/1
  # PUT /bookmarks/1.xml
  def update
    if session[:user_id]
      @bookmark = Bookmark.first(:conditions => {:id => params[:id], :user_id => session[:user_id]})
      if @bookmark 
        @tags = params[:tag]
        
        @bookmark.tags.delete_all
        
        @tags.each do |tag|
          objTag = Tag.find(tag)
          @bookmark.tags << objTag
        end
        respond_to do |format|
          if @bookmark.update_attributes(params[:bookmark])
            format.html { redirect_to(@bookmark, :notice => 'Bookmark was successfully updated.') }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @bookmark.errors, :status => :unprocessable_entity }
          end
        end
      else
         redirect_to "/bookmarks/"
      end
    else
      redirect_to "/login"
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.xml
  def destroy
    if session[:user_id]
      @bookmark = Bookmark.first(:conditions => {:id => params[:id], :user_id => session[:user_id]})
      if @bookmark
        @bookmark = Bookmark.find(params[:id])
        @bookmark.destroy
    
        respond_to do |format|
          format.html { redirect_to(bookmarks_url) }
          format.xml  { head :ok }
        end
      else
        redirect_to "/bookmarks/"
      end
    else
      redirect_to "/login"
    end
  end
  
  def preview
    if session[:user_id]
      
      @bookmarks = Bookmark.all(:conditions => "user_id = "+session[:user_id].to_s)
      user = User.find(session[:user_id])
      
      @background = Rails.root + '/data/' + user.background
      @size = user.size
      @color = user.color
      render :layout => false
#      respond_to do |format|
#        format.html # index.html.erb
#        format.xml  { render :xml => @bookmarks }
#      end
    else
      redirect_to "/login"
    end
  end
  
end
