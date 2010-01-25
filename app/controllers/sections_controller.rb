class SectionsController < ApplicationController
  # GET /locations/:id/sections
  # GET /locations/:id/sections.xml
  def index
    @location = Location.find(params[:location_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sections }
    end
  end

  # GET /locations/:id/sections/1
  # GET /locations/:id/sections/1.xml
  def show
    @section = Section.find(params[:id])
    @location = @section.location

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @section }
    end
  end

  # GET /locations/:id/sections/new
  # GET /locations/:id/sections/new.xml
  def new
    @location = Location.find(params[:location_id])
    @section = Section.new
    @section.location = @location

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @section }
    end
  end

  # GET /locations/:id/sections/1/edit
  def edit
    @section = Section.find(params[:id])
    @location = @section.location
  end

  # POST /locations/:id/sections
  # POST /locations/:id/sections.xml
  def create
    @location = Location.find(params[:location_id])
    @section = Section.new(params[:section])
    @section.location = @location

    respond_to do |format|
      if @section.save
        flash[:notice] = 'Section was successfully created.'
        format.html { redirect_to(location_section_path(@location, @section)) }
        format.xml  { render :xml => @section, :status => :created, :location => location_section_path(@location, @section) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/:id/sections/1
  # PUT /locations/:id/sections/1.xml
  def update
    @section = Section.find(params[:id])
    @location = @section.location

    respond_to do |format|
      if @section.update_attributes(params[:section])
        flash[:notice] = 'Section was successfully updated.'
        format.html { redirect_to(location_section_path(@location, @section)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/:id/sections/1
  # DELETE /locations/:id/sections/1.xml
  def destroy
    @section = Section.find(params[:id])
    @location = @section.location
    @section.destroy

    respond_to do |format|
      format.html { redirect_to(location_sections_path(@location)) }
      format.xml  { head :ok }
    end
  end
end
