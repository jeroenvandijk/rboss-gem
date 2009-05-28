require File.dirname(__FILE__) + '/../spec_helper'

describe Boss::ResultCollection do

  it "should dynamically set instance values given at creation" do
    collection = Boss::ResultCollection.new
    collection.set_instance_variable(:totalhits, "344")
    
    collection.totalhits.should eql("344")
  end
  
  it "should allow iterating over result collection" do
    collection = Boss::ResultCollection.new
    
    collection << 1
    collection << 2
    
    collection.each do |value| 
      [1,2].member?(value).should be_true
    end
    
  end
  
  it "should allow merging two results collections" do
    collection_one = Boss::ResultCollection.new
    collection_one << 1
    collection_two = Boss::ResultCollection.new
    collection_two << 2
    
    collection_one += collection_two
    collection_one.size.should be 2
  end
  
end

describe Boss::ResultCollection, 'implementing the will_paginate collection api' do
  before(:each) do
    @collection = Boss::ResultCollection.new
    @collection.set_instance_variable(:totalhits, "99")
    @collection.set_instance_variable(:count, "10")
    @collection.set_instance_variable(:page_count, "10")
  end
  
  it "should be able to return the collection size" do
    @collection << 1
    @collection << 2
    
    @collection.size.should eql(2)
  end
  
  it "should be empty if no results have been added" do
    @collection.should be_empty
  end
  
  it "should not have a previous page if it is on page 1" do
    @collection.set_instance_variable(:start, "0")
    @collection.previous_page.should be_nil
  end
  
  it "should return the correct previous page" do
    @collection.set_instance_variable(:start, "10")
    @collection.previous_page.should eql(1)
  end
  
  it "should return the correct current page" do
    @collection.set_instance_variable(:start, "10")
    @collection.current_page.should eql(2)
  end
  
  it "should return the correct next page" do
    @collection.set_instance_variable(:start, "10")
    @collection.next_page.should eql(3)
  end
  
  it "should not have a next page if we are on the last page" do
    @collection.set_instance_variable(:start, "90")
    @collection.next_page.should be_nil
  end
  
  it "should return the correct number of total pages" do
    @collection.total_pages.should eql(10)
  end
end