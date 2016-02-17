class ProfessorsClassesController < ApplicationController
  # GET /professors_classes
  # GET /professors_classes.xml
  def index
    @professors_classes = ProfessorsClass.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @professors_classes }
    end
  end

  # GET /professors_classes/1
  # GET /professors_classes/1.xml
  def show
    @professors_class = ProfessorsClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @professors_class }
    end
  end

  # GET /professors_classes/new
  # GET /professors_classes/new.xml
  def new
    @professors_class = ProfessorsClass.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @professors_class }
    end
  end

  # GET /professors_classes/1/edit
  def edit
    @professors_class = ProfessorsClass.find(params[:id])
  end

  # POST /professors_classes
  # POST /professors_classes.xml
  def create
    @professors_class = ProfessorsClass.new(params[:professors_class])

    respond_to do |format|
      if @professors_class.save
        flash[:notice] = 'ProfessorsClass was successfully created.'
        format.html { redirect_to(@professors_class) }
        format.xml  { render :xml => @professors_class, :status => :created, :location => @professors_class }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @professors_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /professors_classes/1
  # PUT /professors_classes/1.xml
  def update
    @professors_class = ProfessorsClass.find(params[:id])

    respond_to do |format|
      if @professors_class.update_attributes(params[:professors_class])
        flash[:notice] = 'ProfessorsClass was successfully updated.'
        format.html { redirect_to(@professors_class) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @professors_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /professors_classes/1
  # DELETE /professors_classes/1.xml
  def destroy
    @professors_class = ProfessorsClass.find(params[:id])
    @professors_class.destroy

    respond_to do |format|
      format.html { redirect_to(professors_classes_url) }
      format.xml  { head :ok }
    end
  end
end
