class LocationsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :show_by_bluetooth_mac]
  
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
  
  def show_by_bluetooth_mac
    @location = Location.find(:first, :conditions => ["bluetooth_mac = ?", params[:id]], :include => [:sections, :comments])
    
    respond_to do |format|
      format.html { render :template => "locations/show" }
      format.xml  { render :xml => format_location_output(@location) }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new
    @location.location_type_id = 1
    @location_types = LocationType.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
    @location_types = LocationType.all
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
        output['sections']['section-'+section.id.to_s] = Hash.new
        output['sections']['section-'+section.id.to_s]['name'] = section.name
        output['sections']['section-'+section.id.to_s]['text'] = section.text
      end
      if !location.comments.empty?
        output['sections']['comments'] = Hash.new
        for comment in location.comments
          output['sections']['comments']['comment-'+comment.id.to_s] = {
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
