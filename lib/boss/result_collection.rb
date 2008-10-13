module Boss
  class ResultCollection 
    include Enumerable

    attr_reader :results

    def initialize
      @results=[]
    end
    
    def set_instance_variable(name, value)
      instance_variable_set("@#{name}",value)
      instance_eval("def #{name}\n @#{name}\n end")        
    end

    def each
      @results.each { |result| yield result }
    end
    
    def <<(element)
      @results << element
    end
    
    def [](key)
      @results[key]
    end
    
    # Implements neccessary api for the will_paginate view helper
    # to work with result sets out of the box
    def size
      @results.size
    end
    
    def empty?
      @results.empty?
    end
    
    def previous_page
      self.current_page == 1 ? nil : self.current_page.to_i-1
    end
    
    def next_page
      self.current_page == self.total_pages ? nil : self.current_page+1
    end
    
    def total_pages
      (self.totalhits.to_f/self.page_count.to_f).ceil
    end
    
    def current_page
      (self.start.to_i/self.page_count.to_i) + 1
    end

  end
end
