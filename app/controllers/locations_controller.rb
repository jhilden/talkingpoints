class LocationsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  
  # GET /locations
  # GET /locations.xml
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find_by_id(params[:id], :include => [:sections, :comments])

    respond_to do |format|
      if @location
        format.html # show.html.erb
        format.xml  { render :xml => format_location_output(@location) }
      else
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => :not_found }
        format.xml { head :status => :not_found }
      end
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])
    @location.user = current_user

    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(@location) }
        format.xml  { render :xml => format_location_output(@location), :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        format.html { redirect_to(@location) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
    def format_location_output(location)
      output = Hash.new
      if location == nil
        return "error"
      end
    
      output = {
        'tpid' => location.id,
        'location_type' => location.location_type.name,
        'status' => 'Currently open for another 4 hours until 11pm'
      }
      Location.content_columns.each do |column|
        output[column.name] = location.send(column.name)
      end
  
      output['sections'] = Hash.new
      location.sections.each do |section|
        output['sections'][section.name] = section.text
      end
      if !location.comments.empty?
        output['sections']['Comments'] = Hash.new
        for comment in location.comments
          output['sections']['Comments']['comment-'+comment.id.to_s] = {
            'id' => comment.id,
            'title' => comment.title,
            'username' => comment.user.username,
            'user_id' => comment.user.id,
            'datetime' => comment.created_at,
            'text' => comment.text,
            'datetime_in_words' => view_helper.distance_of_time_in_words_to_now(comment.created_at)+' ago'
          }
        end
      end
      
      return output
    end
end
