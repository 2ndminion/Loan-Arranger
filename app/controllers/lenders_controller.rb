class LendersController < ApplicationController
  # GET /lenders
  # GET /lenders.xml
  def index
    @lenders = Lender.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lenders }
    end
  end

  # GET /lenders/1
  # GET /lenders/1.xml
  def show
    @lender = Lender.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lender }
    end
  end

  # GET /lenders/new
  # GET /lenders/new.xml
  def new
    @lender = Lender.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lender }
    end
  end

  # GET /lenders/1/edit
  def edit
    @lender = Lender.find(params[:id])
  end

  # POST /lenders
  # POST /lenders.xml
  def create
    @lender = Lender.new(params[:lender])

    respond_to do |format|
      if @lender.save
        flash[:notice] = 'Lender was successfully created.'
        format.html { redirect_to(@lender) }
        format.xml  { render :xml => @lender, :status => :created, :location => @lender }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lender.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lenders/1
  # PUT /lenders/1.xml
  def update
    @lender = Lender.find(params[:id])

    respond_to do |format|
      if @lender.update_attributes(params[:lender])
        flash[:notice] = 'Lender was successfully updated.'
        format.html { redirect_to(@lender) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lender.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lenders/1
  # DELETE /lenders/1.xml
  def destroy
    @lender = Lender.find(params[:id])
    @lender.destroy

    respond_to do |format|
      format.html { redirect_to(lenders_url) }
      format.xml  { head :ok }
    end
  end
end
