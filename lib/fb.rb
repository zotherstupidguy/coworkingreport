require 'json'
require 'open-uri'
require 'redis'
require 'yaml'

@r = Redis.new

#@spaces = Marshal.load(@r.get("spaces",)
#@r.set(@spaces, Marshal.dump())

def fetch_events space 

  @db		= {} 
  @parsed 	= begin
		    YAML.load(File.open("./secret.yml"))
		  rescue ArgumentError => e
		    puts "Could not parse YAML: #{e.message}"
		  end
  @token 	= @parsed["token"]
  @space = space 

  @r.sadd("spaces",@space) unless @r.smembers("spaces").include? @space

  $logger.info("#############################")
  $logger.info(@space)
  $logger.info("#############################")

  #@result = open("https://graph.facebook.com/v2.0/#{space}/events?key=past&access_token=#{@token}")
  #@result = open("https://graph.facebook.com/v2.0/#{@space}/events?key=past&access_token=#{@token}")
  #@result = open("https://graph.facebook.com/v2.0/#{space}/events?fields=name,cover,description,photos&key=past&access_token=#{@token}")
  @result = open("https://graph.facebook.com/v2.5/#{@space}/events?fields=name,cover,description,start_time&key=past&access_token=#{@token}")

  @db[@space] = []

  def action
    @result = JSON.parse(@result.read)
    return if @result["paging"].nil? or @result["paging"]["next"].nil?

    @result["data"].each do |r|
      $logger.info("On #{r["start_time"]} #{r["name"]}")
      @db[@space] << r
    end
    @result = open(@result["paging"]["next"]) 
    action
  end

  action
  @r.set(@space, Marshal.dump(@db[@space]))
  #p  @result["error"]["message"]
  $logger.info(@result)
end

#fetch_events("DistrictEgypt")
#@space = "DistrictEgypt"
#  Marshal.load(@r.get(@space))

def my_corn
  #@spaces = ["DistrictEgypt", "m3mal", "PenguinSquare", "QafeerLabs", "thegreekcampus"]
  # @spaces.each do |space|
  # fetch_events space
  # end
end
