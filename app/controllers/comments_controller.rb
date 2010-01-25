class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  def index
    @location = Location.find(params[:location_id])
    @comments = @location.comments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])
    @location = @comment.location

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @location = Location.find(params[:location_id])
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @location = @comment.location
  end

  # POST /comments
  # POST /comments.xml
  def create
    @location = Location.find(params[:location_id])
    @comment = Comment.new(params[:comment])

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

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])
    @location = @comment.location

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

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @location = @comment.location
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(location_comments_path(@location)) }
      format.xml  { head :ok }
    end
  end
end
