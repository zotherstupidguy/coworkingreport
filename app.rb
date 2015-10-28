require 'sinatra'
require './lib/fb.rb'


get '/' do

  @r			= Redis.new
  @spaces 		= @r.smembers("spaces")
  @upcoming_events 	= []

  @spaces.each do |space|
    @space_events 	= Marshal.load(@r.get(space))

    @space_events.each do |event|
      $logger.info("#{event} is on iteration")

      if !event["start_time"].nil? then 

	@event_date = Time.parse(event["start_time"])

	#@event_date > Time.parse(Time.now.to_s) ?  @coming_up = true : @coming_up = false # unless @event_date.nil? 

	#if @coming_up then 
	if @event_date > Time.parse(Time.now.to_s) 

	  $logger.info("##############")
	  $logger.info("##############")
	  $logger.info("##############")
	  $logger.info("##############")
	  $logger.info("we got an upcoming on #{@event_date} and today is #{Time.parse(Time.now.to_s)}")
	  $logger.info("##############")
	  $logger.info("##############")
	  $logger.info("##############")
	  $logger.info("##############")

	  @upcoming_events << event
	  $logger.info("############### Adding #{event} to @upcoming_events ##############")
	end
      end
    end

  end
  #p "start our logging"
  #p @upcoming_events
  erb :index
end

get '/:space' do
  @r = Redis.new
  if @r.get(params["space"]).nil?
    fetch_events(params["space"])
  end
  @space		= params["space"]
  @space_events 	= Marshal.load(@r.get(params[:space]))
  @total 		= @space_events.count

  erb :space
end
