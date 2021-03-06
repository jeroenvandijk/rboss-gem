$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'boss/api'
require 'boss/config'
require 'boss/result'
require 'boss/result_collection'
require 'boss/result_factory'
require 'boss/version'

module Boss
  YAHOO_VERSION = 1

  module SearchService
    %w[web images news spelling se_inlink].each { |e| const_set(e.upcase, e) }
  end

  FORMATS = %w[xml json]
 
  class BossError < StandardError; end
  class InvalidFormat < StandardError; end
  class InvalidConfig < StandardError; end
end