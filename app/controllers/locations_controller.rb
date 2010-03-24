class LocationsController < ApplicationController
  before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy]
  
  # GET /locations
  def index
    @locations = Location.all

    respond_to do |format|
      format.html {
        center = [42.27, -83.73]
        
        location_markers = Array.new
        @locations.each do |location|
          if location.lat and location.lng
            location_markers << GMarker.new(
              [location.lat, location.lng],
              :title => location.name,
              :info_window => "<strong>"+location.name+"</strong><p>"+location.description+"</p>"
            )
          end
        end
        
        @map = GMap.new("gmap")
        @map.control_init(:large_map => true, :map_type => true)
        @map.center_zoom_init(center, 14)
        @map.overlay_global_init(GMarkerGroup.new(true, location_markers), "locations")
      } # index.html.erb
      format.xml  { render :xml  => format_locations_output(@locations) }
      format.json { render :json => format_locations_output(@locations) }
    end
  end
  
  # GET /locations/by_coordinates
  def by_coordinates
    coordinates = params[:id].split(';')
    coordinates[0].gsub!(',', '.').to_f
    coordinates[1].gsub!(',', '.').to_f
    
    @locations = Location.find(:all, :origin => coordinates, :within => 1)
    
    respond_to do |format|
      format.html {
        center = [@locations[0].lat, @locations[0].lng]
        
        location_markers = Array.new
        @locations.each do |location|
          if location.lat and location.lng
            location_markers << GMarker.new(
              [location.lat, location.lng],
              :title => location.name,
              :info_window => "<strong>"+location.name+"</strong><p>"+location.description+"</p>"
            )
          end
        end
        
        @map = GMap.new("gmap")
        @map.control_init(:large_map => true, :map_type => true)
        @map.center_zoom_init(center, 14)
        @map.overlay_global_init(GMarkerGroup.new(true, location_markers), "locations")
        
        render :template => 'locations/index'
      } # index.html.erb
      format.xml   { render :xml  => format_locations_output(@locations) }
      format.json  { render :json => format_locations_output(@locations) }
    end
  end
  
  # GET /locations/1
  def show
    @location = Location.find_by_id(params[:id], :include => [:sections, :comments, :parent_location, :child_locations])
    
    respond_to do |format|
      if @location
        format.html {
          if @location.lat and @location.lng
            @map = GMap.new("gmap")
            @map.control_init(:large_map => true, :map_type => true)
            @map.center_zoom_init([@location.lat, @location.lng], 14)
            @map.overlay_init(GMarker.new(
                [@location.lat, @location.lng],
                :title => @location.name,
                :info_window => "<strong>"+@location.name+"</strong><p>"+@location.description+"</p>"
            ))
          end
        } # show.html.erb
        format.xml   { render :xml  => format_location_output(@location) }
        format.json  { render :json => format_location_output(@location) }
      else
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => :not_found }
        format.xml  { head :status => :not_found }
        format.json { head :status => :not_found }
      end
    end
  end
  
  # GET /locations/show_by_bluetooth_mac/1234567890
  def show_by_bluetooth_mac
    @location = Location.find(:first, :conditions => ["bluetooth_mac = ?", params[:id]], :include => [:sections, :comments, :parent_location, :child_locations])
    
    respond_to do |format|
      if @location
        format.html {
          if @location.lat and @location.lng
            @map = GMap.new("gmap")
            @map.control_init(:large_map => true, :map_type => true)
            @map.center_zoom_init([@location.lat, @location.lng], 14)
            @map.overlay_init(GMarker.new(
                [@location.lat, @location.lng],
                :title => @location.name,
                :info_window => "<strong>"+@location.name+"</strong><p>"+@location.description+"</p>"
            ))
          end
          
          render :template => "locations/show"
        }
        format.xml  { render :xml  => format_location_output(@location) }
        format.json { render :json => format_location_output(@location) }
      else
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => :not_found }
        format.xml  { head :status => :not_found }
        format.json { head :status => :not_found }
      end
    end
  end  

  # GET /locations/1/get_nearby
  def get_nearby
    @location = Location.find_by_id(params[:id])
    @locations = Location.find(:all, :origin => @location, :within => 1, :order => "distance asc", :conditions => ["id != ?", @location.id])
    
    # this is a bugfix, since geokit doesn't seem to set the distance attribute as it is supposed to be
    @locations.each do |loc|
      loc.distance = loc.distance_from(@location) if loc.distance == nil
    end
    
    respond_to do |format|
      if @location
        format.html  {
          center = [@locations[0].lat, @locations[0].lng]
          
          location_markers = Array.new
          @locations.each do |location|
            if location.lat and location.lng
              location_markers << GMarker.new(
                [location.lat, location.lng],
                :title => location.name,
                :info_window => "<strong>"+location.name+"</strong><p>"+location.description+"</p>"
              )
            end
          end
          
          @map = GMap.new("gmap")
          @map.control_init(:large_map => true, :map_type => true)
          @map.center_zoom_init(center, 14)
          @map.overlay_global_init(GMarkerGroup.new(true, location_markers), "locations")
          
          render :template => 'locations/index'
        }
        format.xml   { render :xml =>  format_locations_output(@locations) }
        format.json  { render :json => format_locations_output(@locations) }
      else
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => :not_found }
        format.xml  { head :status => :not_found }
        format.json { head :status => :not_found }
      end
    end
  end
  
  # GET /locations/new
  def new
    @location = Location.new
    @location.location_type_id = 1
    @location_types = LocationType.all
    @locations = Location.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
    @location_types = LocationType.all
    @locations = Location.all
  end

  # POST /locations
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
  
    def format_locations_output(locations)
      output = Hash.new
      #markers = Array.new
      locations.each do |loc|
        output['location-'+loc.id.to_s] = {
          'tpid'          => loc.id,
          'lat'           => loc.lat,
          'lng'           => loc.lng,
          'bluetooth_mac' => loc.bluetooth_mac,
          'distance'      => loc.distance.to_f * 1000
        }
        #markers << GMarker.new([loc.lat, loc.lng], :info_window => loc.name)
      end
      return output
    end
end
