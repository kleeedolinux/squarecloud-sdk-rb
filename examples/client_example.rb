require 'squarecloud'


client = Squarecloud::Client.new(api_key: 'YOUR_API_KEY')


user = client.user
puts "User: #{user.username}"
puts "Plan: #{user.plan}"


puts "\nApplications:"
apps = client.all_apps
apps.each do |app|
  puts "- #{app.id} (#{app.name})"
end


if apps.any?
  app = apps.first
  puts "\nApplication Status for #{app.name}:"
  status = app.status
  puts "Running: #{status.running}"
  puts "CPU: #{status.cpu}%"
  puts "RAM: #{status.ram}MB"
  
  
  puts "\nLogs:"
  logs = app.logs
  puts logs.logs
end 