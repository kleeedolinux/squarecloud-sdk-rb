require 'squarecloud'


client = Squarecloud::Client.new(api_key: 'YOUR_API_KEY')


app_id = 'YOUR_APP_ID'


files = client.app_files_list(app_id, '/')
puts "Files in root directory:"
files.each do |file|
  puts "- 
end


file_path = 'squarecloud.app'
content = client.read_app_file(app_id, file_path)
puts "\nContent of 
puts content


new_file = Squarecloud::File.new('local_file.txt', 'text/plain')
client.create_app_file(app_id, new_file, '/new_file.txt')
puts "\nCreated new file: /new_file.txt"


client.move_app_file(app_id, '/new_file.txt', '/moved_file.txt')
puts "Moved file from /new_file.txt to /moved_file.txt"


client.delete_app_file(app_id, '/moved_file.txt')
puts "Deleted file: /moved_file.txt" 