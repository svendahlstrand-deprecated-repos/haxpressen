require 'bundler/setup'

require 'mongoid'
require 'open-uri'
require 'nokogiri'
require 'builder'
require 'rack'

require_relative 'entry'
require_relative 'miner'

ENV['RACK_ENV'] ||= 'development'

Mongoid.load! File.expand_path('../../mongoid.yml', __FILE__)
