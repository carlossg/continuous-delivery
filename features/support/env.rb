require 'capybara'
require 'capybara/cucumber'
require 'capybara/poltergeist'

Capybara.default_driver = :poltergeist
Capybara.app_host = ENV['URL']
