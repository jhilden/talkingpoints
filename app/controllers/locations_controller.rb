include Geokit::Geocoders

class LocationsController < ApplicationController
  before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy]
  
  # GET /locations
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml  => format_locations_output(@locations) }
      format.json { render :json => format_locations_output(@locations) }
    end
  end
  
  # GET /locations/by_coordinates/12,345;67,890
  def by_coordinates
    coordinates = params[:id].split(';')
    coordinates[0].gsub!(',', '.').to_f
    coordinates[1].gsub!(',', '.').to_f
    
    @locations = Location.find(:all, :origin => coordinates, :within => 1)
    
    respond_to do |format|
      format.html  { render :template => 'locations/index' }
      format.xml   { render :xml  => format_locations_output(@locations) }
      format.json  { render :json => format_locations_output(@locations) }
    end
  end
  
  # GET /locations/1
  def show
    @location = Location.find_by_automatic(params[:id], {:include => [:sections, :comments, :parent_location, :child_locations]})
    
    respond_to do |format|
      if @location
        format.html { render :template => "locations/show" }
        format.xml  { render :xml  => format_location_output(@location) }
        format.json { render :json => format_location_output(@location) }
      else
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => :not_found }
        format.xml  { head :status => :not_found }
        format.json { head :status => :not_found }
      end
    end
  end
  alias show_by_bluetooth_mac show

  # GET /locations/1/get_nearby
  def get_nearby
    @location = Location.find_by_automatic(params[:id])
    
    
    respond_to do |format|
      if @location
        options_hash = {:origin => @location, :conditions => ["id != ?", @location.id]}
        options_hash[:within] = (params[:within] ? params[:within] : 1)
        options_hash[:units] = :kms  if params[:units] == 'kms'
        
        @locations = Location.find(:all, options_hash)
        
        
        format.html  { render :template => 'locations/index' }
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
  
  # GET /location/1/geocode
  # TODO: this should probably not use a HTTP GET request and it might also make more sense to move it to a different controller or the model
  def geocode
    @location = Location.find(params[:id])
    if @location.lat.blank? or @location.lng.blank?
      res = MultiGeocoder.geocode(@location.street + ', ' + @location.city + ', ' + @location.state + ', ' + @location.country)
      
      if !res.lng.blank? or !res.lat.blank?
        @location.lat = res.lat
        @location.lng = res.lng
        @location.save
        flash[:notice] = 'Geocoding results: ' + res.lat.to_s + ', ' + res.lng.to_s
        
      else
        flash[:notice] = 'Geocoding failed'
      end
      
    end
    
    respond_to do |format|
      format.html { redirect_to(@location) }
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
      if location.parent_location
        output['parent_location'] = {
          'tpid'          => location.parent_location.id,
          'name'          => location.parent_location.name,
          'lat'           => location.parent_location.lat,
          'lng'           => location.parent_location.lng,
          'bluetooth_mac' => location.parent_location.bluetooth_mac
        }
      end
      
      # child_locations
      if !location.child_locations.empty?
        output['child_locations'] = Array.new
        for child_location in location.child_locations
          output['child_locations'] << {
            'tpid'          => child_location.id,
            'name'          => child_location.name,
            'lat'           => child_location.lat,
            'lng'           => child_location.lng,
            'bluetooth_mac' => child_location.bluetooth_mac
          }
        end
      end
      
      # sections
      output['sections'] = Hash.new
      location.sections.each do |section|
        output['sections']['section-'+section.id.to_s] = Hash.new
        output['sections']['section-'+section.id.to_s]['name'] = section.name
        output['sections']['section-'+section.id.to_s]['text'] = section.text
      end
      
      # comments
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
      output = Array.new
      locations.each do |loc|
        output_loc = {
          'tpid'          => loc.id,
          'name'          => loc.name,
          'lat'           => loc.lat,
          'lng'           => loc.lng,
          'bluetooth_mac' => loc.bluetooth_mac,
          'floor_number'  => loc.floor_number
        }
        output_loc['distance'] = loc.distance.to_f    if loc.respond_to?('distance')
        output << output_loc
      end
      return output
    end
end
