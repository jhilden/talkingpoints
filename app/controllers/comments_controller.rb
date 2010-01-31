class CommentsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  
  # GET /locations/:id/comments
  # GET /locations/:id/comments.xml
  def index
    @location = Location.find(params[:location_id])
    @comments = @location.comments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /locations/:id/comments/1
  # GET /locations/:id/comments/1.xml
  def show
    @comment = Comment.find(params[:id])
    @location = @comment.location

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /locations/:id/comments/new
  # GET /locations/:id/comments/new.xml
  def new
    @location = Location.find(params[:location_id])
    @comment = Comment.new()
    @comment.location = @location

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /locations/:id/comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @location = @comment.location
    if @comment.user != current_user
      flash[:notice] = "You are not allowed to edit this comment."
      redirect_to(location_comment_path(@location, @comment)) and return
    end
  end

  # POST /locations/:id/comments
  # POST /locations/:id/comments.xml
  def create
    @location = Location.find(params[:location_id])
    @comment = Comment.new(params[:comment])
    @comment.location = @location
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(location_comment_path(@location, @comment)) }
        format.xml  { render :xml => @comment, :status => :created, :location => location_comment_pth(@location, @comment) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/:id/comments/1
  # PUT /locations/:id/comments/1.xml
  def update
    @comment = Comment.find_by_id(params[:id])
    @location = @comment.location
    
    if @comment.user != current_user
      flash[:notice] = "You are not allowed to update this comment."
      redirect_to(location_comment_path(@location, @comment)) and return
    end
    
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(location_comment_path(@location, @comment)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/:id/comments/1
  # DELETE /locations/:id/comments/1.xml
  def destroy
    @comment = Comment.find_by_id(params[:id])
    @location = @comment.location
    
    if @comment.user != current_user
      flash[:notice] = "You are not allowed to delete this comment."
      redirect_to(location_comment_path(@location, @comment)) and return
    end
    
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(location_comments_path(@location)) }
      format.xml  { head :ok }
    end
  end
end
