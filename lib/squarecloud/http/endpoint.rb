module Squarecloud
  module HTTP
    class Endpoint
      ENDPOINTS = {
        'USER' => { 'METHOD' => 'GET', 'PATH' => '/users/me' },
        'APP_DATA' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}' },
        'APP_STATUS' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}/status' },
        'ALL_APPS_STATUS' => { 'METHOD' => 'GET', 'PATH' => '/apps/status' },
        'ALL_BACKUPS' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}/backups' },
        'LOGS' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}/logs' },
        'START' => { 'METHOD' => 'POST', 'PATH' => '/apps/{app_id}/start' },
        'STOP' => { 'METHOD' => 'POST', 'PATH' => '/apps/{app_id}/stop' },
        'RESTART' => { 'METHOD' => 'POST', 'PATH' => '/apps/{app_id}/restart' },
        'BACKUP' => { 'METHOD' => 'POST', 'PATH' => '/apps/{app_id}/backups' },
        'COMMIT' => { 'METHOD' => 'POST', 'PATH' => '/apps/{app_id}/commit' },
        'DELETE_APP' => { 'METHOD' => 'DELETE', 'PATH' => '/apps/{app_id}' },
        'UPLOAD_APP' => { 'METHOD' => 'POST', 'PATH' => '/apps' },
        'FILES_LIST' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}/files?path={path}' },
        'FILES_READ' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}/files/content?path={path}' },
        'FILES_CREATE' => { 'METHOD' => 'PUT', 'PATH' => '/apps/{app_id}/files' },
        'FILES_DELETE' => { 'METHOD' => 'DELETE', 'PATH' => '/apps/{app_id}/files' },
        'MOVE_FILE' => { 'METHOD' => 'PATCH', 'PATH' => '/apps/{app_id}/files' },
        'LAST_DEPLOYS' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}/deployments' },
        'CURRENT_INTEGRATION' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}/deployments/current' },
        'GITHUB_INTEGRATION' => { 'METHOD' => 'POST', 'PATH' => '/apps/{app_id}/deploy/webhook' },
        'CUSTOM_DOMAIN' => { 'METHOD' => 'POST', 'PATH' => '/apps/{app_id}/network/custom' },
        'DOMAIN_ANALYTICS' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}/network/analytics' },
        'DNSRECORDS' => { 'METHOD' => 'GET', 'PATH' => '/apps/{app_id}/network/dns' }
      }.freeze
      
      attr_reader :name, :method, :path
      
      def initialize(name)
        endpoint = ENDPOINTS[name]
        raise ArgumentError, "Invalid endpoint: '
        
        @name = name
        @method = endpoint['METHOD']
        @path = endpoint['PATH']
      end
      
      def build_path(params = {})
        path = @path.dup
        params.each do |key, value|
          placeholder = "{
          path = path.gsub(placeholder, value.to_s) if path.include?(placeholder)
        end
        path
      end
      
      def ==(other)
        other.is_a?(Endpoint) && @name == other.name
      end
      
      def to_s
        "Endpoint('
      end
      
      class << self
        def user
          new('USER')
        end
        
        def app_data
          new('APP_DATA')
        end
        
        def app_status
          new('APP_STATUS')
        end
        
        def logs
          new('LOGS')
        end
        
        def start
          new('START')
        end
        
        def stop
          new('STOP')
        end
        
        def restart
          new('RESTART')
        end
        
        def backup
          new('BACKUP')
        end
        
        def commit
          new('COMMIT')
        end
        
        def delete_app
          new('DELETE_APP')
        end
        
        def upload
          new('UPLOAD_APP')
        end
        
        def files_list
          new('FILES_LIST')
        end
        
        def files_read
          new('FILES_READ')
        end
        
        def files_create
          new('FILES_CREATE')
        end
        
        def files_delete
          new('FILES_DELETE')
        end
        
        def last_deploys
          new('LAST_DEPLOYS')
        end
        
        def github_integration
          new('GITHUB_INTEGRATION')
        end
        
        def domain_analytics
          new('DOMAIN_ANALYTICS')
        end
        
        def custom_domain
          new('CUSTOM_DOMAIN')
        end
        
        def all_backups
          new('ALL_BACKUPS')
        end
        
        def all_apps_status
          new('ALL_APPS_STATUS')
        end
        
        def current_integration
          new('CURRENT_INTEGRATION')
        end
        
        def move_file
          new('MOVE_FILE')
        end
        
        def dns_records
          new('DNSRECORDS')
        end
      end
    end
  end
end 