require 'squarecloud'


client = Squarecloud::Client.new(api_key: 'YOUR_API_KEY')


user = client.user
puts "User: 
puts "Plan: 


puts "\nApplications:"
apps = client.all_apps
apps.each do |app|
  puts "- 
end


if apps.any?
  app = apps.first
  puts "\nApplication Status for 
  status = app.status
  puts "Running: 
  puts "CPU: 
  puts "RAM: 
  
  
  puts "\nLogs:"
  logs = app.logs
  puts logs.logs
end 