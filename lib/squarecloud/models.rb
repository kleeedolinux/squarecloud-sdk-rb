require 'date'

module Squarecloud
  class PlanData
    attr_reader :name, :memory, :duration
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @name = data[:name]
      @memory = data[:memory]
      @duration = data[:duration]
    end
    
    def to_h
      {
        name: @name,
        memory: @memory,
        duration: @duration
      }
    end
  end
  
  class Language
    attr_reader :name, :version
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @name = data[:name]
      @version = data[:version]
    end
    
    def to_h
      {
        name: @name,
        version: @version
      }
    end
  end
  
  class StatusData
    attr_reader :cpu, :ram, :status, :running, :storage, :network, :requests, :uptime, :time
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @cpu = data[:cpu]
      @ram = data[:ram]
      @status = data[:status]
      @running = data[:running]
      @storage = data[:storage]
      @network = data[:network]
      @requests = data[:requests]
      @uptime = data[:uptime]
      @time = data[:time]
    end
    
    def to_h
      {
        cpu: @cpu,
        ram: @ram,
        status: @status,
        running: @running,
        storage: @storage,
        network: @network,
        requests: @requests,
        uptime: @uptime,
        time: @time
      }
    end
  end
  
  class ResumedStatus
    attr_reader :id, :running, :cpu, :ram
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @id = data[:id]
      @running = data[:running]
      @cpu = data[:cpu]
      @ram = data[:ram]
    end
    
    def to_h
      {
        id: @id,
        running: @running,
        cpu: @cpu,
        ram: @ram
      }
    end
  end
  
  class AppData
    attr_reader :id, :name, :cluster, :ram, :language, :domain, :custom, :desc
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @id = data[:id]
      @name = data[:name]
      @cluster = data[:cluster]
      @ram = data[:ram]
      @language = data[:language]
      @domain = data[:domain]
      @custom = data[:custom]
      @desc = data[:desc]
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
  
  class UserData
    attr_reader :id, :name, :plan, :email, :apps
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @id = data[:id]
      @name = data[:name]
      @plan = data[:plan] ? PlanData.new(data[:plan]) : nil
      @email = data[:email]
      @apps = data[:apps] || []
    end
    
    def to_h
      {
        id: @id,
        name: @name,
        plan: @plan&.to_h,
        email: @email,
        apps: @apps
      }
    end
  end
  
  class LogsData
    attr_reader :logs
    
    def initialize(data)
      @logs = data[:logs] || ''
    end
    
    def ==(other)
      other.is_a?(LogsData) && @logs == other.logs
    end
    
    def to_h
      {
        logs: @logs
      }
    end
  end
  
  class BackupInfo
    attr_reader :name, :size, :modified, :key
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @name = data[:name]
      @size = data[:size]
      @modified = data[:modified] ? DateTime.parse(data[:modified]) : nil
      @key = data[:key]
    end
    
    def to_h
      {
        name: @name,
        size: @size,
        modified: @modified,
        key: @key
      }
    end
  end
  
  class Backup
    attr_reader :url, :key
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @url = data[:url]
      @key = data[:key]
    end
    
    def to_h
      {
        url: @url,
        key: @key
      }
    end
    
    def download(path = './')
      require 'open-uri'
      require 'zip'
      
      zip_path = File.join(path, "backup_
      IO.copy_stream(URI.open(@url), zip_path)
      Zip::File.open(zip_path)
    end
  end
  
  class UploadData
    attr_reader :id, :name, :language, :ram, :cpu, :domain, :description
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @id = data[:id]
      @name = data[:name]
      @language = data[:language] ? Language.new(data[:language]) : nil
      @ram = data[:ram]
      @cpu = data[:cpu]
      @domain = data[:domain]
      @description = data[:description]
    end
    
    def to_h
      {
        id: @id,
        name: @name,
        language: @language&.to_h,
        ram: @ram,
        cpu: @cpu,
        domain: @domain,
        description: @description
      }
    end
  end
  
  class FileInfo
    attr_reader :app_id, :type, :name, :last_modified, :path, :size
    
    def initialize(app_id, data)
      @app_id = app_id
      return unless data.is_a?(Hash)
      
      @type = data[:type]
      @name = data[:name]
      @last_modified = data[:lastModified]
      @path = data[:path]
      @size = data[:size] || 0
    end
    
    def to_h
      {
        app_id: @app_id,
        type: @type,
        name: @name,
        last_modified: @last_modified,
        path: @path,
        size: @size
      }
    end
  end
  
  class DeployData
    attr_reader :id, :state, :date
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @id = data[:id]
      @state = data[:state]
      @date = data[:date] ? DateTime.parse(data[:date]) : nil
    end
    
    def to_h
      {
        id: @id,
        state: @state,
        date: @date
      }
    end
  end
  
  class AnalyticsTotal
    attr_reader :visits, :megabytes, :bytes
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @visits = data[:visits]
      @megabytes = data[:megabytes]
      @bytes = data[:bytes]
    end
    
    def to_h
      {
        visits: @visits,
        megabytes: @megabytes,
        bytes: @bytes
      }
    end
  end
  
  class DomainAnalytics
    class Analytics
      attr_reader :total, :countries, :methods, :referers, :browsers,
                  :device_types, :operating_systems, :agents, :hosts, :paths
      
      def initialize(data)
        return unless data.is_a?(Hash)
        
        @total = data[:total] ? data[:total].map { |t| AnalyticsTotal.new(t) } : []
        @countries = data[:countries] || []
        @methods = data[:methods] || []
        @referers = data[:referers] || []
        @browsers = data[:browsers] || []
        @device_types = data[:deviceTypes] || []
        @operating_systems = data[:operatingSystems] || []
        @agents = data[:agents] || []
        @hosts = data[:hosts] || []
        @paths = data[:paths] || []
      end
      
      def to_h
        {
          total: @total.map(&:to_h),
          countries: @countries,
          methods: @methods,
          referers: @referers,
          browsers: @browsers,
          device_types: @device_types,
          operating_systems: @operating_systems,
          agents: @agents,
          hosts: @hosts,
          paths: @paths
        }
      end
    end
    
    class Domain
      attr_reader :hostname, :analytics
      
      def initialize(data)
        return unless data.is_a?(Hash)
        
        @hostname = data[:hostname]
        @analytics = data[:analytics] ? Analytics.new(data[:analytics]) : nil
      end
      
      def to_h
        {
          hostname: @hostname,
          analytics: @analytics&.to_h
        }
      end
    end
    
    class Custom
      attr_reader :analytics
      
      def initialize(data)
        return unless data.is_a?(Hash)
        
        @analytics = data[:analytics] ? Analytics.new(data[:analytics]) : nil
      end
      
      def to_h
        {
          analytics: @analytics&.to_h
        }
      end
    end
    
    attr_reader :domain, :custom
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @domain = data[:domain] ? Domain.new(data[:domain]) : nil
      @custom = data[:custom] ? Custom.new(data[:custom]) : nil
    end
    
    def to_h
      {
        domain: @domain&.to_h,
        custom: @custom&.to_h
      }
    end
  end
  
  class DNSRecord
    attr_reader :type, :name, :value, :status
    
    def initialize(data)
      return unless data.is_a?(Hash)
      
      @type = data[:type]
      @name = data[:name]
      @value = data[:value]
      @status = data[:status]
    end
    
    def to_h
      {
        type: @type,
        name: @name,
        value: @value,
        status: @status
      }
    end
  end
end 