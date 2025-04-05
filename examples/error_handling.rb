
require_relative '../lib/squarecloud'


begin
  
  client = Squarecloud::Client.new(api_key: 'INVALID_API_KEY')
  
  
  user_data = client.user
rescue Squarecloud::AuthenticationFailure => e
  puts "Authentication Error:"
  puts "  Message: 
  puts "  Route: 
  puts "  Status: 
  puts "  Code: 
end


begin
  client = Squarecloud::Client.new(api_key: ENV['SQUARECLOUD_API_KEY'] || 'YOUR_API_KEY')
  
  
  app = client.app('NON_EXISTENT_APP_ID')
rescue Squarecloud::ApplicationNotFound => e
  puts "\nApplication Not Found Error:"
  puts "  Message: 
  puts "  App ID: 
end


begin
  client = Squarecloud::Client.new(api_key: ENV['SQUARECLOUD_API_KEY'] || 'YOUR_API_KEY')
  
  
  result = client.set_custom_domain('SOME_APP_ID', 'invalid-domain')
rescue Squarecloud::InvalidDomain => e
  puts "\nInvalid Domain Error:"
  puts "  Message: 
  puts "  Domain: 
  puts "  Route: 
  puts "  Status: 
  puts "  Code: 
end


def handle_api_request(client)
  begin
    
    result = client.user
    puts "Request successful!"
    puts result.to_h
  rescue Squarecloud::AuthenticationFailure => e
    puts "Authentication failed: 
  rescue Squarecloud::NotFoundError => e
    puts "Resource not found: 
  rescue Squarecloud::TooManyRequests => e
    puts "Rate limited: 
    
  rescue Squarecloud::RequestError => e
    puts "API request error: 
    puts "  Route: 
    puts "  Status code: 
    puts "  Error code: 
  rescue Squarecloud::Error => e
    puts "General error: 
  end
end

puts "\nGeneral error handling demonstration:"
handle_api_request(Squarecloud::Client.new(api_key: 'INVALID')) 