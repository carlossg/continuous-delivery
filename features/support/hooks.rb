def take_screen_capture
  path = "target/screenshots/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}-screenshot.png"
  page.driver.render(path)
end

# Save a screenshot on for failed scenarios
After('~@api,~@smoke_tests') do |scenario|
  if scenario.failed?
    take_screen_capture
  end
end
