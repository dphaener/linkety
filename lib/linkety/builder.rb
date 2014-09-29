require "uri"

module Linkety
  class Builder
    attr_reader :request
    
    def initialize(template, request)
      @template = template
      @request = request
    end
    
    def active_link_to_if(truth, text, url, options = {})
      active_class = options.delete(:active_class) || "active"
      inactive_class = options.delete(:inactive_class) || "inactive"
      inactive_url = options.delete(:inactive_url) || "#"
      klasses = (options.delete(:class) || "").split(' ')
      
      klasses << (truth ? active_class : inactive_class)
      url = inactive_url unless truth
      
      t.link_to(text, url, options.merge(:class => klasses.join(' ')))
    end
    
    def current_link_to(text, url, options = nil, &block)
      text, url, options = block, text, url if block_given?
      options ||= {}

      href_path = extract_path(url)
      current_class = options.delete(:current_class) || "current"
      klasses = (options.delete(:class) || "").split(' ')
      pattern = options.delete(:pattern)
      
      if pattern
        klasses << current_class if current_path =~ pattern
      else
        klasses << current_class if current_path == href_path
      end
        
      t.link_to(text, url, options.merge(:class => klasses.join(' ')), &block)
    end
    
    def current_link_to_if(truth, text, url, options = {})
      current_class = options.delete(:current_class) || "current"
      klasses = (options.delete(:class) || "").split(' ')
      klasses << current_class if truth
      t.link_to(text, url, options.merge(:class => klasses.join(' ')))
    end
    
  private
  
    # Private: The template passed in to the initializer.
    #
    # Returns an ActionView::Base object.
    def t
      @template
    end
    
    # Private: The path of the current request.
    #
    # Returns a String.
    def current_path
      raise "A Request object must be present" unless request
      fullpath = request.fullpath
      extract_path(fullpath)
    end
    
    # Private: Extract just the path portion of a URL without the query string.
    #
    # uri - A String URL.
    #
    # Examples
    #
    #   extract_path("http://google.com/foo/bar")
    #   => "/foo/bar"
    #
    #   extract_path("/foo/bar/que?order=asc")
    #   => "/foo/bar/que"
    #
    # Returns a String.
    def extract_path(uri)
      parsed_uri = URI(uri)
      parsed_uri.path
    end
  end
end