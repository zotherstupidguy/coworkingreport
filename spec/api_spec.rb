require_relative './helper_spec'

describe 'fb_api' do
  before do
    @r = Redis.new
    require 'logger'
    $logger = Logger.new(STDOUT)

=begin
    @db		= {}
    @parsed 	= begin
		    YAML.load(File.open("./secret.yml"))
		  rescue ArgumentError => e
		    puts "Could not parse YAML: #{e.message}"
		  end
    @token 	= @parsed["token"]
    @space 	= space 
    @r.sadd("spaces",@space) unless @r.smembers("spaces").include? @space
=end

  end

  describe "fetch_events" do
    it "takes a space and returns a datatype? of events" do
      fetch_events("TheDistrict").must_equal "X"
    end
  end

  it "adds the requested space" do
    #@blog.title.must_equal "Treehouse Blog"
  end

end
