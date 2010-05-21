class BundlesController < ApplicationController
  # GET /bundles
  # GET /bundles.xml
  def index
    if !params[:bundle_id].nil?
      @bundles = Bundle.find("id=?",params[:bundle_id])
    else
      @bundles = Bundle.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bundles }
    end
  end
  
  # GET /bundles
  # GET /bundles.xml
  def index_loans_for_bundle
    @bundles = Bundle.find(params[:id])

    respond_to do |format|
      format.html { render 'loans/index'}
      format.xml  { render :xml => @bundles }
    end
  end

  # GET /bundles/1
  # GET /bundles/1.xml
  def show
    @bundle = Bundle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bundle }
    end
  end

  def investment_request
    respond_to do |format|
      format.html #autobundle.html.erb
      #format.json { render :json => rtndata.to_json}
    end    
  end
  
  def search_for_best_bundle
    @bundles = Bundle.all
    @bundles.delete_if { |bundle|
      risk = 0
      sub1 = 0
      sub2 = 0
      profit = 0
      mark = false
      termTooLongFlag = false
      bundle.loans.each { |loan|
        sub1 += (loan.risk * loan.amount)
        sub2 += loan.amount
        # Compound interest: P(1 + r)^t, where I = interest, P = principal, r = rate of interest, and t = the time duration of the loan
        profit += loan.amount * (1+loan.interest_rate.to_f) ** loan.term.to_i 
        termTooLongFlag = true if loan.term.to_i > params[:bundle][:max_term].to_i
      }
      risk = sub1/sub2
      #puts "\n THE PROFIT FOR BUNDLE #{bundle.id} IS: #{profit}\n AND THE MIN PROFIT IS:" + params[:bundle][:min_profit]
      true if risk > params[:bundle][:max_risk].to_i || profit < params[:bundle][:min_profit].to_f || termTooLongFlag == true      
    }
    
    respond_to do |format|
      format.html { render 'bundles/index'}
      #format.json { render :json => rtndata.to_json}
    end    
  end
  
  # GET /bundles/new
  # GET /bundles/new.xml
  def new
    @bundle = Bundle.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bundle }
    end
  end

  # GET /bundles/1/edit
  def edit
    @bundle = Bundle.find(params[:id])
  end

  # POST /bundles
  # POST /bundles.xml
  def create
    @bundle = Bundle.new(params[:bundle])

    respond_to do |format|
      if @bundle.save
        flash[:notice] = 'Bundle was successfully created.'
        format.html { redirect_to(@bundle) }
        format.xml  { render :xml => @bundle, :status => :created, :location => @bundle }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bundle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bundles/1
  # PUT /bundles/1.xml
  def update
    @bundle = Bundle.find(params[:id])

    respond_to do |format|
      if @bundle.update_attributes(params[:bundle])
        flash[:notice] = 'Bundle was successfully updated.'
        format.html { redirect_to(@bundle) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bundle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bundles/1
  # DELETE /bundles/1.xml
  def destroy
    @bundle = Bundle.find(params[:id])
    @bundle.destroy

    respond_to do |format|
      format.html { redirect_to(bundles_url) }
      format.xml  { head :ok }
    end
  end
end
