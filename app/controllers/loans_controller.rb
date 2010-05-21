class LoansController < ApplicationController
  # GET /loans
  # GET /loans.xml
  def index
    start = 20
    size = 10
    start = params[:start].to_i+1 if !params[:start].blank?   
    size = params[:size].to_i if !params[:size].blank?
    #start=(params[:start] || 0).to_i
    #size = (params[:limit] || 20).to_i
    page = ((start/size).to_i) if start != 1
    #sort = "#{params[:sort]}#{params[:dir]}" || "id asc"
    #@loans = Loan.paginate(:all,
    #  :page => page,
    #  :per_page => size,
    #  :order => sort)
    
    if !params[:bundle_id].nil?
      # Todo: Research using Rails magic to do @loans = Budle.find().loans instead with will_paginate
      @loans = Loan.paginate(:all, :page => page, :order => "id ASC", :conditions => ["bundle_id=?",params[:bundle_id]])
    else
      @loans = Loan.paginate(:all, :page => page)
    end
        
    #@loans = Loan.paginate(:all, :page => page)
    rtndata = {}
    rtndata[:total] = @loans.total_entries
    rtndata[:loans] = @loans.collect { |l| {
      :id => l.id,
      :lender => l.lender.name,
      :status => l.status,
      :amount => l.amount,
      :settlement_date => l.settlement_date,
      :command_show_link => l.id
    }}
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => rtndata.to_json}
    end
    
  end
  
  def autobundle
    @loans = Loan.all(:conditions => ["risk > ?",params[:max_risk]])
    puts "Hello out there from autobundle!"
    respond_to do |format|
      format.html #autobundle.html.erb
      #format.json { render :json => rtndata.to_json}
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
