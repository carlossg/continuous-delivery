require 'rubygems'
require 'bundler/setup'
require 'rspec/expectations'
require 'capybara'
require 'capybara/cucumber'
require 'socket'
require 'capybara-webkit'

Capybara.default_driver = :webkit

Capybara.app_host = ENV['URL']
