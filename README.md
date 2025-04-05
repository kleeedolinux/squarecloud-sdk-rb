# Square Cloud Ruby SDK (Unofficial)

An unofficial Ruby SDK for the [Square Cloud](https://squarecloud.app/) API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'squarecloud-unofficial'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install squarecloud-unofficial
```

## Getting API Key

To get your API key/token, go to the [Square Cloud](https://squarecloud.app) website and register/login. 
After that, navigate to `dashboard` > `my account` > `Regenerate API/CLI KEY` and copy the key.

## Usage

### Authentication

To use the SDK, you need to authenticate with your API key from the Square Cloud dashboard.

```ruby
require 'squarecloud'

# Initialize the client with your API key
client = Squarecloud::Client.new(api_key: 'YOUR_API_KEY')
```

### User Information

```ruby
# Get user information
user = client.user
puts "User: #{user.name}"
puts "Plan: #{user.plan.name}"
```

### Application Management

```ruby
# List all applications
apps = client.all_apps
apps.each do |app|
  puts "#{app.name} (#{app.id})"
end

# Get a specific application by ID
app = client.app('APP_ID')

# Get application status
status = app.status
puts "Running: #{status.running}"
puts "CPU: #{status.cpu}"
puts "RAM: #{status.ram}"

# Get application logs
logs = app.logs
puts logs.logs

# Start, stop, and restart an application
app.start
app.stop
app.restart

# Delete an application
app.delete
```

### File Operations

```ruby
# List files in a directory
files = app.files_list('/')
files.each do |file|
  puts "#{file.name} (#{file.type}, #{file.size} bytes)"
end

# Read a file's content
content = app.read_file('/path/to/file')

# Create a new file
new_file = Squarecloud::File.new('local_file.txt', 'text/plain')
app.create_file(new_file, '/path/in/app.txt')

# Move a file
app.move_file('/old/path.txt', '/new/path.txt')

# Delete a file
app.delete_file('/path/to/file.txt')
```

### Backups

```ruby
# Create a backup
backup = app.backup
puts "Backup URL: #{backup.url}"

# List all backups
backups = app.all_backups
backups.each do |backup|
  puts "#{backup.name} (#{backup.size} bytes)"
end

# Download a backup
backup.download('./backups/')
```

### Domain Management

```ruby
# Set a custom domain
app.set_custom_domain('example.com')

# Get domain analytics
analytics = app.domain_analytics
visits = analytics.domain.analytics.total.first.visits
puts "Total visits: #{visits}"

# Get DNS records
records = app.dns_records
records.each do |record|
  puts "#{record.type} #{record.name} #{record.value}"
end
```

### GitHub Integration

```ruby
# Set up GitHub integration
app.create_github_integration('GITHUB_TOKEN')

# Get current integration
integration = app.current_integration
puts "Current integration: #{integration}"
```

## Examples

For more examples, check the `examples/` directory in this repository:

- `examples/client_example.rb` - Basic usage of the client
- `examples/file_operations.rb` - Examples of file operations

## Disclaimer

This is an **unofficial** SDK not affiliated with or endorsed by Square Cloud. This project was created to provide Ruby developers with an easy way to interact with the Square Cloud API.

## Contributing

Feel free to contribute with suggestions or bug reports at our GitHub repository.

## License

This SDK is available as open source under the terms of the MIT License.
