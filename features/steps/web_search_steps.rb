require 'spec'
$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'boss'

Before do
end

After do
end

Given "a valid API key" do
  @api = Boss::Api.new("put-your-api-key-here")
end

When /^I do the following search$/ do |table|
  # Do integer conversions
  table.send :map_headers!, 'limit' => :limit, 'count' => :count
  table.map_column!(:limit) { |x| x.nil? ? nil : x.to_i }
  table.map_column!(:count) { |x| x.nil? ? nil : x.to_i }

  search_options = table.hashes.first  

  type = search_options.delete('type')
  term = search_options.delete('term')

  case type
  when 'web'
    @results = @api.search_web(term, search_options)    
  when 'news'
    @results = @api.search_news(term, search_options)    
  when 'images'
    @results = @api.search_images(term, search_options)
  when 'spell'
    @results = @api.search_spelling(term, search_options)
  when 'inlinks'
    @results = @api.search_inlinks(term, search_options)
  else
    raise Exception.new "invalid search: #{type}"
  end
end

Then /I will receive search results/ do
  @results.results.nil?.should == false
end

Then /^I will receive "([^\"]*)" search results$/ do |number_of_results|
  @results.results.size.should == number_of_results.to_i
end

Then /I will be able to see the total hits/ do
  @results.totalhits.to_i.should > 0 
end
