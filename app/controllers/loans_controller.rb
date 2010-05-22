class LoansController < ApplicationController
  layout 'application'
  
  # GET /loans
  # GET /loans.xml
  def index
    start = 20
    size = 10
    sort = "id ASC"
    start = params[:start].to_i+1 if !params[:start].blank?   
    size = params[:size].to_i if !params[:size].blank?
    page = ((start/size).to_i) if start != 1
    sort = "#{params[:sort]} #{params[:dir]}" if !params[:sort].blank?
    #@loans = Loan.paginate(:all,
    #  :page => page,
    #  :per_page => size,
    #  :order => sort)
    
    if !params[:bundle_id].nil?
      # Todo: Research using Rails magic to do @loans = Bundle.find().loans instead with will_paginate
      @loans = Loan.paginate(:all, :page => page, :order => sort, :conditions => ["bundle_id=?",params[:bundle_id]])
    else
      @loans = Loan.paginate(:all, :page => page, :order => sort)
    end
        
    rtndata = {}
    rtndata[:total] = @loans.total_entries
    rtndata[:loans] = @loans.collect { |l| {
      :id => l.id,
      :lender => l.lender.name,
      :status => l.status,
      :amount => l.amount,
      :interest_rate => l.interest_rate,
      :risk => l.risk,
      :term => l.term,
      :settlement_date => l.created_at.strftime('%B %Y'),
      :bundle => unless l.bundle.nil? then  l.bundle.name  else  "Not Bundled" end,
      :command_links => l.id,
      :selected => false
    }}
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => rtndata.to_json}
    end
    
  end
  
  def autobundle   
  end
  
  def toggle_lock
    puts "RECEIVED AJAX CALL ID IS: #{params[:id]}"
    @loan = Loan.find(params[:id])
    @loan.toggle!(:locked)
    rtndata = {}
    rtndata[:success] = true
    respond_to do |format|
      #format.html #autobundle.html.erb
      format.json { render :json => rtndata.to_json}
    end    
  end

  # GET /loans/1
  # GET /loans/1.xml
  def show
    @loan = Loan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @loan }
    end
  end

  # GET /loans/new
  # GET /loans/new.xml
  def new
    @loan = Loan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @loan }
    end
  end

  # GET /loans/1/edit
  def edit
    @loan = Loan.find(params[:id])
  end

  # POST /loans
  # POST /loans.xml
  def create
    @loan = Loan.new(params[:loan])

    respond_to do |format|
      if @loan.save
        flash[:notice] = 'Loan was successfully created.'
        format.html { redirect_to(@loan) }
        format.xml  { render :xml => @loan, :status => :created, :location => @loan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @loan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /loans/1
  # PUT /loans/1.xml
  def update
    @loan = Loan.find(params[:id])

    respond_to do |format|
      if @loan.update_attributes(params[:loan])
        flash[:notice] = 'Loan was successfully updated.'
        format.html { redirect_to(@loan) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @loan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1
  # DELETE /loans/1.xml
  def destroy
    @loan = Loan.find(params[:id])
    @loan.destroy

    respond_to do |format|
      format.html { redirect_to(loans_url) }
      format.xml  { head :ok }
    end
  end
end
