class TagsController < ApplicationController
  
  layout "template"
  
  # GET /tags
  # GET /tags.xml
  def index
    if session[:user_id] == 5
      @tags = Tag.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @tags }
      end
    else
      redirect_to "/bookmarks"
    end
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    if session[:user_id] == 5
      @tag = Tag.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @tag }
      end
    else
      redirect_to "/bookmarks"
    end
  end

  # GET /tags/new
  # GET /tags/new.xml
  def new
    if session[:user_id] == 5
      @tag = Tag.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @tag }
      end
    else
      redirect_to "/bookmarks"
    end
  end

  # GET /tags/1/edit
  def edit
    if session[:user_id] == 5
      @tag = Tag.find(params[:id])
    else
      redirect_to "/bookmarks"
    end
  end

  # POST /tags
  # POST /tags.xml
  def create
    if session[:user_id] == 5
      @tag = Tag.new(params[:tag])

      respond_to do |format|
        if @tag.save
          format.html { redirect_to(@tag, :notice => 'Tag was successfully created.') }
          format.xml  { render :xml => @tag, :status => :created, :location => @tag }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
        end
      end 
    else
      redirect_to "/bookmarks"
    end
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    if session[:user_id] == 5
      @tag = Tag.find(params[:id])

      respond_to do |format|
        if @tag.update_attributes(params[:tag])
          format.html { redirect_to(@tag, :notice => 'Tag was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to "/bookmarks"
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    if session[:user_id] == 5
      @tag = Tag.find(params[:id])
      @tag.destroy
  
      respond_to do |format|
        format.html { redirect_to(tags_url) }
        format.xml  { head :ok }
      end
    else
      redirect_to "/bookmarks"
    end
  end
end
