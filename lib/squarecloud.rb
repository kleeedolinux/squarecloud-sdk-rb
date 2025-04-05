require 'faraday'
require 'faraday/multipart'


require_relative 'squarecloud/version'

module Squarecloud
  class Error < StandardError
    attr_reader :message
    
    def initialize(message = 'An unexpected error occurred')
      @message = message
      super(message)
    end
    
    def to_s
      @message
    end
  end
  
  class RequestError < Error
    attr_reader :route, :status, :code
    
    def initialize(route: nil, status_code: nil, code: nil, message: nil)
      @route = route
      @status = status_code
      @code = code
      @message = message || "route [
      super(@message)
    end
  end
  
  class AuthenticationFailure < RequestError
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code, 
            message: 'Authentication failed: Invalid API token or access denied')
    end
  end
  
  class NotFoundError < RequestError
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Resource not found: 404')
    end
  end
  
  class BadRequestError < RequestError
  end
  
  class ApplicationNotFound < Error
    attr_reader :app_id
    
    def initialize(app_id)
      @app_id = app_id
      super("No application was found with id: 
    end
  end
  
  class InvalidFile < Error
    def initialize
      super('Invalid file')
    end
  end
  
  class MissingConfigFile < RequestError
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Configuration file is missing')
    end
  end
  
  class MissingDependenciesFile < RequestError
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Dependencies file is missing')
    end
  end
  
  class TooManyRequests < RequestError
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Too many requests')
    end
  end
  
  class FewMemory < RequestError
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Insufficient memory available')
    end
  end
  
  class BadMemory < RequestError
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'No memory available')
    end
  end
  
  class InvalidConfig < RequestError
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Invalid config file')
    end
  end
  
  class InvalidDisplayName < InvalidConfig
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Invalid display name in config file')
    end
  end
  
  class MissingDisplayName < InvalidConfig
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Display name is missing in the config file')
    end
  end
  
  class InvalidMain < InvalidConfig
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Invalid main file in config file')
    end
  end
  
  class MissingMainFile < InvalidConfig
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Main file is missing in the config file')
    end
  end
  
  class InvalidMemory < InvalidConfig
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Invalid memory value in config file')
    end
  end
  
  class MissingMemory < InvalidConfig
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Memory value is missing in the config file')
    end
  end
  
  class InvalidVersion < InvalidConfig
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Invalid version value in config file')
    end
  end
  
  class MissingVersion < InvalidConfig
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Version value is missing in the config file')
    end
  end
  
  class InvalidAccessToken < RequestError
  end
  
  class InvalidDomain < RequestError
    attr_reader :domain
    
    def initialize(domain: nil, route: nil, status_code: nil, code: nil, **kwargs)
      @domain = domain
      super(route: route, status_code: status_code, code: code,
            message: "\"
    end
  end
  
  class InvalidStart < InvalidConfig
    def initialize(route: nil, status_code: nil, code: nil, **kwargs)
      super(route: route, status_code: status_code, code: code,
            message: 'Invalid start value in configuration file')
    end
  end
end


require_relative 'squarecloud/http/endpoint'
require_relative 'squarecloud/http/client'
require_relative 'squarecloud/models'
require_relative 'squarecloud/application'


module Squarecloud
  class Client
    attr_reader :api_key, :http
    
    def initialize(api_key:)
      @api_key = api_key
      @http = Squarecloud::HTTP::Client.new(api_key: api_key)
    end
    
    def user
      response = @http.fetch_user_info
      Squarecloud::UserData.new(response)
    end
    
    def app(app_id)
      response = @http.get_app_data(app_id)
      Squarecloud::Application.new(http: @http, data: response)
    end
    
    def all_apps
      user_data = user
      user_data.apps.map do |app_data|
        app(app_data[:id])
      end
    end
    
    def app_status(app_id)
      response = @http.fetch_app_status(app_id)
      Squarecloud::StatusData.new(response)
    end
    
    def get_logs(app_id)
      response = @http.fetch_logs(app_id)
      Squarecloud::LogsData.new(response)
    end
    
    def start_app(app_id)
      @http.start_application(app_id)
      true
    end
    
    def stop_app(app_id)
      @http.stop_application(app_id)
      true
    end
    
    def restart_app(app_id)
      @http.restart_application(app_id)
      true
    end
    
    def backup(app_id)
      response = @http.backup(app_id)
      Squarecloud::Backup.new(response)
    end
    
    def delete_app(app_id)
      @http.delete_application(app_id)
      true
    end
    
    def commit(app_id, file)
      @http.commit(app_id, file)
      true
    end
    
    def upload_app(file)
      response = @http.upload(file)
      Squarecloud::UploadData.new(response)
    end
    
    def app_files_list(app_id, path)
      response = @http.fetch_app_files_list(app_id, path)
      response.map { |file_data| Squarecloud::FileInfo.new(app_id, file_data) }
    end
    
    def read_app_file(app_id, path)
      @http.read_app_file(app_id, path)
    end
    
    def create_app_file(app_id, file, path)
      @http.create_app_file(app_id, file, path)
      true
    end
    
    def delete_app_file(app_id, path)
      @http.file_delete(app_id, path)
      true
    end
    
    def app_data(app_id)
      response = @http.get_app_data(app_id)
      Squarecloud::AppData.new(response)
    end
    
    def last_deploys(app_id)
      response = @http.get_last_deploys(app_id)
      response.map do |deploy_group|
        deploy_group.map { |deploy| Squarecloud::DeployData.new(deploy) }
      end
    end
    
    def github_integration(app_id, access_token)
      @http.create_github_integration(app_id, access_token)
    end
    
    def set_custom_domain(app_id, custom_domain)
      @http.update_custom_domain(app_id, custom_domain)
      true
    end
    
    def domain_analytics(app_id)
      response = @http.domain_analytics(app_id)
      Squarecloud::DomainAnalytics.new(response)
    end
    
    def all_app_backups(app_id)
      response = @http.get_all_app_backups(app_id)
      response.map { |backup| Squarecloud::BackupInfo.new(backup) }
    end
    
    def all_apps_status
      response = @http.all_apps_status
      response.map { |status| Squarecloud::ResumedStatus.new(status) }
    end
    
    def move_app_file(app_id, origin, dest)
      @http.move_app_file(app_id, origin, dest)
      true
    end
    
    def dns_records(app_id)
      response = @http.dns_records(app_id)
      response.map { |record| Squarecloud::DNSRecord.new(record) }
    end
    
    def current_app_integration(app_id)
      @http.get_app_current_integration(app_id)
    end
  end
end 