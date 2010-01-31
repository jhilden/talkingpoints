class LocationTypesController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  
  # GET /location_types
  # GET /location_types.xml
  def index
    @location_types = LocationType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @location_types }
    end
  end

  # GET /location_types/1
  # GET /location_types/1.xml
  def show
    @location_type = LocationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location_type }
    end
  end

  # GET /location_types/new
  # GET /location_types/new.xml
  def new
    @location_type = LocationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location_type }
    end
  end

  # GET /location_types/1/edit
  def edit
    @location_type = LocationType.find(params[:id])
  end

  # POST /location_types
  # POST /location_types.xml
  def create
    @location_type = LocationType.new(params[:location_type])

    respond_to do |format|
      if @location_type.save
        flash[:notice] = 'LocationType was successfully created.'
        format.html { redirect_to(@location_type) }
        format.xml  { render :xml => @location_type, :status => :created, :location => @location_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /location_types/1
  # PUT /location_types/1.xml
  def update
    @location_type = LocationType.find(params[:id])

    respond_to do |format|
      if @location_type.update_attributes(params[:location_type])
        flash[:notice] = 'LocationType was successfully updated.'
        format.html { redirect_to(@location_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /location_types/1
  # DELETE /location_types/1.xml
  def destroy
    @location_type = LocationType.find(params[:id])
    @location_type.destroy

    respond_to do |format|
      format.html { redirect_to(location_types_url) }
      format.xml  { head :ok }
    end
  end
end
