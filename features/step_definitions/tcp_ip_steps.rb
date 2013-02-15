Then /^the "(.*?)" service should be listening on port "(.*?)"$/ do |service, port|
  timeout = 60
  polling_interval = 2
  time_limit = Time.now + timeout
  host = URI.parse(Capybara.app_host).host
  loop do
    begin
      s = TCPSocket.new(host, port)
      s.close
      break
    rescue Exception => error
    end
    raise("#{service} is not listening at #{host} on port #{port}") if Time.now >= time_limit
    sleep polling_interval
  end

end

Then /^services should be listening on ports:$/ do |table|

  table.raw.each do |value|
    step %{the "#{value[1]}" service should be listening on port "#{value[0]}"}
  end
end
