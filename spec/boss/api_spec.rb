require File.dirname(__FILE__) + '/../spec_helper'
# require File.dirname(__FILE__) + '/../../boss/api.rb'

describe Boss::Api do

  yahoo_error=<<-EOF
  <Error xmlns="urn:yahoo:api"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="http://api.yahoo.com/Api/V1/error.xsd">
    The following errors were detected:
    <Message>Service not found. Please see http://developer.yahoo.net for service locations</Message>
  </Error>
  EOF

  #TODO: Mock HTTPSuccess
  def mock_http_response(stubs={})
    # mock('Net::HTTPSuccess',{:head => Net::HTTPSuccess.new('1.2', '200', 'OK'), :body => '{"ysearchresponse":{}}' })
    mock('http_response', {:body => yahoo_json, :code => "200"}.merge(stubs))
  end
  
  def mock_http_response_with_one_record(stubs={})
    mock_http_response(:body => yahoo_json)
  end
  
  def yahoo_json(hash = {})
    defaults = {:nextpage => "nextpage", :totalhits => "1000"}
    %[{"ysearchresponse": #{defaults.merge(hash).to_json} }]
  end

  before(:each) do
    @api = Boss::Api.new( appid = 'test' )
    @api.endpoint = 'http://www.example.com/'
  end

  describe "responding to spelling search" do

    it "should make a spelling request to yahoo service" do
      Net::HTTP.should_receive(:get_response).and_return{ mock_http_response }

      @api.search_spelling("girafes")
    end

    it "should build the spelling objects" do
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response }
      Boss::ResultFactory.should_receive(:build).with(yahoo_json)

      @api.search_spelling("girafes")
    end

  end

  describe "responding to news search" do
    it "should make a news request to yahoo service" do
      Net::HTTP.should_receive(:get_response).and_return{ mock_http_response }

      @api.search_news("monkey")
    end

    it "should build the news objects" do
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response }
      Boss::ResultFactory.should_receive(:build).with(yahoo_json)

      @api.search_news("monkey")
    end
  end

  describe "responding to image search" do
    it "should make a image request to yahoo service" do
      Net::HTTP.should_receive(:get_response).and_return{ mock_http_response }

      @api.search_images("hippo")
    end

    it "should build the image objects" do
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response }
      Boss::ResultFactory.should_receive(:build).with(yahoo_json)

      @api.search_images("hippo")
    end
  end

  describe "responding to web search" do

    it "should make a web request to yahoo service" do
      Net::HTTP.should_receive(:get_response).and_return{ mock_http_response }

      @api.search_web("monkey")
    end

    it "should build the web objects" do
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response }
      Boss::ResultFactory.should_receive(:build).with(yahoo_json)

      @api.search_web("monkey")
    end

  end

  describe "failed search" do

    it "should raise error on failed search" do
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response :code => "404" }

      lambda { @api.search_web("monkey")  }.should raise_error(Boss::BossError)
    end
    
    it "should extract error from xml on failed search" do
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response :code => "404", :body => yahoo_error }

      lambda { @api.search_web("monkey")  }.should raise_error(Boss::BossError, 'Service not found. Please see http://developer.yahoo.net for service locations')
    end

  end

  describe "configuring search" do

    before(:each) do
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response }

      @config = Boss::Config.new
    end

    it "should allow configuring through block" do
      @config.should_receive(:count=).with(1)
      Boss::Config.should_receive(:new).and_return(@config)

      result = @api.search_web("monkeys") do |setup|
        setup.count = 1
      end
    end

    it "should allow configuring through hash" do
      Boss::Config.should_receive(:new).with({:count => 1}).and_return(@config)

      @api.search_web("monkeys", :count => 1)
    end

  end

  describe "formats" do

    before(:each) do
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response }
    end

    it "should not return any objects when format is 'xml'" do
      Boss::ResultFactory.should_receive(:build).never
      @api.search_web("monkeys", :format => 'xml', :count => 1)
    end

    it "should not return any objects when format is 'json'" do
      Boss::ResultFactory.should_receive(:build).never
      @api.search_web("monkeys", :format => 'json', :count => 1)
    end

    it "should raise an error invalid format" do
      lambda { @api.search_web("monkeys", :format => 'grilled_cheese', :count => 1) }.should raise_error(Boss::InvalidFormat)
    end

    it "should raise an error on invalid count" do
      lambda { @api.search_web("monkeys", :count => 0) }.should raise_error(Boss::InvalidConfig)
    end
    
    it "should raise an error on invalid app id" do
      @api = Boss::Api.new( app_id = '' )

      lambda { @api.search("monkeys", :count => 1) }.should raise_error(Boss::InvalidConfig)
    end

  end

  describe "search should still work when get returns a successful but not code 200" do
    it "should description" do
      pending("fix for http://eshopworks.lighthouseapp.com/projects/15732/tickets/1")
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response :code => "206" }

      lambda { @api.search_web("monkey")  }.should_not raise_error(Boss::BossError)
    end
  end

  describe "searching terms" do
    it "should encode invalid characters" do
      Net::HTTP.stub!(:get_response).and_return{ mock_http_response }
      CGI.stub!(:escape)
      CGI.should_receive(:escape).with('monkey?magic').and_return('monkey%3Fmagic')
      
      @api.search_web("monkey?magic")
    end
    
  end
  
  describe "#next_page" do
    it "should request the next results when 'nextpage' is given" do
      response_mock = mock_http_response(:body => yahoo_json(:nextpage => "nextpage"))
    
      Net::HTTP.should_receive(:get_response).exactly(2).times.and_return{ response_mock }
      @api.search_web("monkey?magic", :count => 1)
      @api.next_page.should be_kind_of Boss::ResultCollection
    end
    
    it "should not request the next results when 'nextpage' is nil" do
      response_mock = mock_http_response(:body => yahoo_json(:nextpage => nil))
    
      Net::HTTP.should_receive(:get_response).exactly(1).times.and_return{ response_mock }
      @api.search_web("monkey?magic", :count => 1)
      @api.next_page.should be_nil
    end
  end
  
  describe "#previous_page" do
    it "should request the next results when 'nextpage' is given" do
      response_mock = mock_http_response(:body => yahoo_json(:prevpage => "prevpage"))
    
      Net::HTTP.should_receive(:get_response).exactly(2).times.and_return{ response_mock }
      @api.search_web("monkey?magic", :count => 1)
      @api.previous_page.should be_kind_of Boss::ResultCollection
    end
    
    it "should not request the next results when 'nextpage' is nil" do
      response_mock = mock_http_response(:body => yahoo_json(:prevpage => nil))
    
      Net::HTTP.should_receive(:get_response).exactly(1).times.and_return{ response_mock }
      @api.search_web("monkey?magic", :count => 1)
      @api.previous_page.should be_nil
    end
  end
  
  describe "MAX_COUNT" do
    it "should be 50" do
      Boss::Api::MAX_COUNT.should eql 50
    end
  end
  
  describe "#search" do
    
    [ {:count => 2,   :limit => 100, :number_of_requests => 50, :totalhits => "400"},
      {:count => 50,  :limit => 100, :number_of_requests => 2,  :totalhits => "400"},
      {:count => 3,   :limit => 50,  :number_of_requests => 17, :totalhits => "50"},
      {:count => 3,   :limit => 50,  :number_of_requests => 14, :totalhits => "40"},
      {:count => 100, :limit => 1,   :number_of_requests => 1,  :totalhits => "40"}
    ].each do |prop|
      it "should do #{prop[:number_of_requests]} number of requests when count is #{prop[:count]} and limit is #{prop[:limit]}" do
        response_mock = mock_http_response(:body => yahoo_json(:nextpage => "nextpage", :totalhits => prop[:totalhits]))
        Net::HTTP.should_receive(:get_response).exactly(prop[:number_of_requests]).times.and_return{ response_mock }
        @api.search_web("monkey?magic", :count => prop[:count], :limit => prop[:limit])
      end
      
    end
  end
end
