module Squarecloud
  class File
    attr_reader :path, :mime_type, :filename
    
    def initialize(path, mime_type = 'application/zip')
      @path = path
      @mime_type = mime_type
      @filename = ::File.basename(path)
    end
  end
  
  class Application
    attr_reader :id, :name, :cluster, :ram, :language, :domain, :custom, :desc
    
    def initialize(http:, data:)
      @http = http
      
      if data.is_a?(Hash)
        @id = data[:id]
        @name = data[:name]
        @cluster = data[:cluster]
        @ram = data[:ram]
        @language = data[:language]
        @domain = data[:domain]
        @custom = data[:custom]
        @desc = data[:desc]
      else
        
        
        @id = nil
      end
    end
    
    def status
      response = @http.fetch_app_status(@id)
      StatusData.new(response)
    end
    
    def logs
      response = @http.fetch_logs(@id)
      LogsData.new(response)
    end
    
    def start
      @http.start_application(@id)
      true
    end
    
    def stop
      @http.stop_application(@id)
      true
    end
    
    def restart
      @http.restart_application(@id)
      true
    end
    
    def backup
      response = @http.backup(@id)
      Backup.new(response)
    end
    
    def delete
      @http.delete_application(@id)
      true
    end
    
    def commit(file)
      @http.commit(@id, file)
      true
    end
    
    def files_list(path)
      response = @http.fetch_app_files_list(@id, path)
      response.map { |file_data| FileInfo.new(@id, file_data) }
    end
    
    def read_file(path)
      @http.read_app_file(@id, path)
    end
    
    def create_file(file, path)
      @http.create_app_file(@id, file, path)
      true
    end
    
    def delete_file(path)
      @http.file_delete(@id, path)
      true
    end
    
    def move_file(origin, dest)
      @http.move_app_file(@id, origin, dest)
      true
    end
    
    def last_deploys
      response = @http.get_last_deploys(@id)
      response.map do |deploy_group|
        deploy_group.map { |deploy| DeployData.new(deploy) }
      end
    end
    
    def create_github_integration(access_token)
      @http.create_github_integration(@id, access_token)
    end
    
    def current_integration
      @http.get_app_current_integration(@id)
    end
    
    def domain_analytics
      response = @http.domain_analytics(@id)
      DomainAnalytics.new(response)
    end
    
    def set_custom_domain(custom_domain)
      @http.update_custom_domain(@id, custom_domain)
      true
    end
    
    def all_backups
      response = @http.get_all_app_backups(@id)
      response.map { |backup| BackupInfo.new(backup) }
    end
    
    def dns_records
      response = @http.dns_records(@id)
      response.map { |record| DNSRecord.new(record) }
    end
    
    def to_h
      {
        id: @id,
        name: @name,
        cluster: @cluster,
        ram: @ram,
        language: @language,
        domain: @domain,
        custom: @custom,
        desc: @desc
      }
    end
  end
end 