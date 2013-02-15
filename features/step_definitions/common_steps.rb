# This file contains general UI testing steps.

Given /^I am at the "(.*?)" page$/ do |path|
  visit path
end

Then /^I should see the text "([^"]*)"$/ do |text|
  page.should have_content text
end

