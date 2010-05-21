namespace :db do 
    desc "Erase and populate Sites, Forms and Leads data for User 1 and Company 1"
    task :populate => :environment do
      require 'populator'
      @banksounding = ["Federal","Capital","First","Community","Bank of","America's","Mutual"]
      
      def randomDate(params={})
        years_back = params[:year_range] || 5
        latest_year  = params [:year_latest] || 0
        year = (rand * (years_back)).ceil + (Time.now.year - latest_year - years_back)
        month = (rand * 12).ceil
        day = (rand * 31).ceil
        series = [date = Time.local(year, month, day)]
        if params[:series]
          params[:series].each do |some_time_after|
            series << series.last + (rand * some_time_after).ceil
          end
          return series
        end
        date
      end
      
      Lender.populate 1..10 do |lender|
          lender.name = @banksounding.rand.to_s + " " + Populator.words(1..2).titleize
          Loan.populate 1..5 do |loan|
            loan.lender_id = lender.id
            loan.status = "good"
            loan.amount = rand * 100450.00
            loan.interest_rate = rand * 15.0
            loan.settlement_date = randomDate(:year_range => 60, :year_latest => 22)
            loan.risk = rand(100)
            loan.term = rand(30)
          end
      end
    end
end