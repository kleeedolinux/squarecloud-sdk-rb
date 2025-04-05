require_relative '../lib/squarecloud'


begin
  
  client = Squarecloud::Client.new(api_key: 'INVALID_API_KEY')
  
  
  user_data = client.user
rescue Squarecloud::AuthenticationFailure => e
  puts "Authentication Error:"
  puts "  Message: #{e.message}"
  puts "  Route: #{e.route}"
  puts "  Status: #{e.status}"
  puts "  Code: #{e.code}"
end


begin
  client = Squarecloud::Client.new(api_key: ENV['SQUARECLOUD_API_KEY'] || 'YOUR_API_KEY')
  
  
  app = client.app('NON_EXISTENT_APP_ID')
rescue Squarecloud::ApplicationNotFound => e
  puts "\nApplication Not Found Error:"
  puts "  Message: #{e.message}"
  puts "  App ID: #{e.app_id}"
end


begin
  client = Squarecloud::Client.new(api_key: ENV['SQUARECLOUD_API_KEY'] || 'YOUR_API_KEY')
  
  
  result = client.set_custom_domain('SOME_APP_ID', 'invalid-domain')
rescue Squarecloud::InvalidDomain => e
  puts "\nInvalid Domain Error:"
  puts "  Message: #{e.message}"
  puts "  Domain: #{e.domain}"
  puts "  Route: #{e.route}"
  puts "  Status: #{e.status}"
  puts "  Code: #{e.code}"
end


def handle_api_request(client)
  begin
    
    result = client.user
    puts "Request successful!"
    puts result.to_h
  rescue Squarecloud::AuthenticationFailure => e
    puts "Authentication failed: #{e.message}"
  rescue Squarecloud::NotFoundError => e
    puts "Resource not found: #{e.message}"
  rescue Squarecloud::TooManyRequests => e
    puts "Rate limited: #{e.message}"
    
  rescue Squarecloud::RequestError => e
    puts "API request error: #{e.message}"
    puts "  Route: #{e.route}"
    puts "  Status code: #{e.status}"
    puts "  Error code: #{e.code}"
  rescue Squarecloud::Error => e
    puts "General error: #{e.message}"
  end
end

puts "\nGeneral error handling demonstration:"
handle_api_request(Squarecloud::Client.new(api_key: 'INVALID')) 