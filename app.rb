require 'sinatra'
require './lib/fb.rb'


get '/' do
  @r			= Redis.new
  @spaces 		= @r.smembers("spaces")
  @upcoming_events 	= []

  @spaces.each do |space|
    @data 	= Marshal.load(@r.get(space))

    @data.each do |event|
      p event

      if !event["start_time"].nil? then 
	@event_date = Time.parse(event["start_time"])
	@event_date > Time.now ?  @coming_up = true : @coming_up = false unless @event_date.nil? 
	if @coming_up then 
	  @upcoming_events << event
	end
      end
    end
  
  end
  p "start our logging"
  p @upcoming_events
  erb :index
end

get '/:space' do
  @r = Redis.new
  if @r.get(params["space"]).nil?
    fetch_events(params["space"])
  end
  @space	= params["space"]
  @data 	= Marshal.load(@r.get(params[:space]))
  @total 	= @data.count

  erb :space
end
