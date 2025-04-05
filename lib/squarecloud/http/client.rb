module Squarecloud
  module HTTP
    class Response
      attr_reader :data, :route, :status, :code, :message, :response
      
      def initialize(data, route)
        @data = data
        @route = route
        @status = data.is_a?(Hash) ? data[:status] : nil
        @code = data.is_a?(Hash) ? data[:code] : nil
        @message = data.is_a?(Hash) ? data[:message] : nil
        @response = data.is_a?(Hash) ? data[:response] : data
      end
      
      def to_s
        "
      end
    end
    
    class Client
      BASE_URL = 'https://api.squarecloud.app/v2'.freeze
      
      attr_reader :api_key, :last_response
      
      def initialize(api_key:)
        @api_key = api_key
        @last_response = nil
      end
      
      def request(endpoint, method: 'GET', params: {}, multipart: false, body: nil)
        conn = Faraday.new(url: BASE_URL) do |f|
          f.request :multipart if multipart
          f.request :json
          f.response :json, content_type: /\bjson$/
          f.adapter Faraday.default_adapter
        end
        
        url = endpoint.build_path(params)
        
        begin
          response = conn.send(method.downcase) do |req|
            req.url url
            req.headers['Authorization'] = @api_key
            req.headers['User-Agent'] = "squarecloud-ruby/
            req.body = body if body
          end
          
          data = response.body
          extra_error_kwargs = {}
          
          
          if params[:custom_domain]
            extra_error_kwargs[:domain] = params[:custom_domain]
          end
          
          
          case response.status
          when 401
            raise Squarecloud::AuthenticationFailure.new(
              route: endpoint.name,
              status_code: response.status,
              code: data.is_a?(Hash) ? data[:code] : nil
            )
          when 404
            raise Squarecloud::NotFoundError.new(
              route: endpoint.name,
              status_code: response.status,
              code: data.is_a?(Hash) ? data[:code] : nil
            )
          when 400
            error_code = data.is_a?(Hash) ? data[:code] : nil
            error_class = get_error(error_code)
            if error_class
              raise error_class.new(
                route: endpoint.name,
                status_code: response.status,
                code: error_code,
                **extra_error_kwargs
              )
            else
              raise Squarecloud::BadRequestError.new(
                route: endpoint.name,
                status_code: response.status,
                code: error_code,
                message: "Bad request: 
              )
            end
          when 429
            raise Squarecloud::TooManyRequests.new(
              route: endpoint.name,
              status_code: response.status,
              code: data.is_a?(Hash) ? data[:code] : nil
            )
          end
          
          
          @last_response = Response.new(data, endpoint)
          
          if @last_response.status == 'error'
            error_class = get_error(@last_response.code)
            if error_class
              raise error_class.new(
                route: endpoint.name,
                status_code: response.status,
                code: @last_response.code,
                **extra_error_kwargs
              )
            else
              raise Squarecloud::RequestError.new(
                route: endpoint.name,
                status_code: response.status,
                code: @last_response.code,
                message: "Request error: 
              )
            end
          end
          
          @last_response.response
        rescue Faraday::Error => e
          
          raise Squarecloud::RequestError.new(
            route: endpoint.name,
            message: "Network error: 
          )
        end
      end
      
      def get_error(code)
        errors = {
          'FEW_MEMORY' => Squarecloud::FewMemory,
          'BAD_MEMORY' => Squarecloud::BadMemory,
          'MISSING_CONFIG' => Squarecloud::MissingConfigFile,
          'MISSING_DEPENDENCIES_FILE' => Squarecloud::MissingDependenciesFile,
          'MISSING_MAIN' => Squarecloud::MissingMainFile,
          'INVALID_MAIN' => Squarecloud::InvalidMain,
          'INVALID_DISPLAY_NAME' => Squarecloud::InvalidDisplayName,
          'MISSING_DISPLAY_NAME' => Squarecloud::MissingDisplayName,
          'INVALID_MEMORY' => Squarecloud::InvalidMemory,
          'MISSING_MEMORY' => Squarecloud::MissingMemory,
          'INVALID_VERSION' => Squarecloud::InvalidVersion,
          'MISSING_VERSION' => Squarecloud::MissingVersion,
          'INVALID_ACCESS_TOKEN' => Squarecloud::InvalidAccessToken,
          'REGEX_VALIDATION' => Squarecloud::InvalidDomain,
          'INVALID_START' => Squarecloud::InvalidStart
        }
        
        errors[code]
      end
      
      def fetch_user_info
        endpoint = Squarecloud::HTTP::Endpoint.user
        request(endpoint)
      end
      
      def fetch_app_status(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.app_status
        request(endpoint, params: { app_id: app_id })
      end
      
      def fetch_logs(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.logs
        request(endpoint, params: { app_id: app_id })
      end
      
      def start_application(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.start
        request(endpoint, method: 'POST', params: { app_id: app_id })
      end
      
      def stop_application(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.stop
        request(endpoint, method: 'POST', params: { app_id: app_id })
      end
      
      def restart_application(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.restart
        request(endpoint, method: 'POST', params: { app_id: app_id })
      end
      
      def backup(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.backup
        request(endpoint, method: 'POST', params: { app_id: app_id })
      end
      
      def delete_application(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.delete_app
        request(endpoint, method: 'DELETE', params: { app_id: app_id })
      end
      
      def commit(app_id, file)
        endpoint = Squarecloud::HTTP::Endpoint.commit
        form_data = { file: Faraday::Multipart::FilePart.new(file.path, file.mime_type) }
        request(endpoint, method: 'POST', params: { app_id: app_id }, multipart: true, body: form_data)
      end
      
      def upload(file)
        endpoint = Squarecloud::HTTP::Endpoint.upload
        form_data = { file: Faraday::Multipart::FilePart.new(file.path, file.mime_type) }
        request(endpoint, method: 'POST', multipart: true, body: form_data)
      end
      
      def fetch_app_files_list(app_id, path)
        endpoint = Squarecloud::HTTP::Endpoint.files_list
        request(endpoint, params: { app_id: app_id, path: path })
      end
      
      def read_app_file(app_id, path)
        endpoint = Squarecloud::HTTP::Endpoint.files_read
        request(endpoint, params: { app_id: app_id, path: path })
      end
      
      def create_app_file(app_id, file, path)
        endpoint = Squarecloud::HTTP::Endpoint.files_create
        form_data = { file: Faraday::Multipart::FilePart.new(file.path, file.mime_type), path: path }
        request(endpoint, method: 'PUT', params: { app_id: app_id }, multipart: true, body: form_data)
      end
      
      def file_delete(app_id, path)
        endpoint = Squarecloud::HTTP::Endpoint.files_delete
        request(endpoint, method: 'DELETE', params: { app_id: app_id, path: path })
      end
      
      def get_app_data(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.app_data
        request(endpoint, params: { app_id: app_id })
      end
      
      def get_last_deploys(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.last_deploys
        request(endpoint, params: { app_id: app_id })
      end
      
      def create_github_integration(app_id, github_access_token)
        endpoint = Squarecloud::HTTP::Endpoint.github_integration
        request(endpoint, method: 'POST', params: { app_id: app_id }, body: { access_token: github_access_token })
      end
      
      def update_custom_domain(app_id, custom_domain)
        endpoint = Squarecloud::HTTP::Endpoint.custom_domain
        request(endpoint, method: 'POST', params: { app_id: app_id, custom_domain: custom_domain }, body: { custom_domain: custom_domain })
      end
      
      def domain_analytics(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.domain_analytics
        request(endpoint, params: { app_id: app_id })
      end
      
      def get_all_app_backups(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.all_backups
        request(endpoint, params: { app_id: app_id })
      end
      
      def all_apps_status
        endpoint = Squarecloud::HTTP::Endpoint.all_apps_status
        request(endpoint)
      end
      
      def move_app_file(app_id, origin, dest)
        endpoint = Squarecloud::HTTP::Endpoint.move_file
        request(endpoint, method: 'PATCH', params: { app_id: app_id }, body: { origin: origin, dest: dest })
      end
      
      def dns_records(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.dns_records
        request(endpoint, params: { app_id: app_id })
      end
      
      def get_app_current_integration(app_id)
        endpoint = Squarecloud::HTTP::Endpoint.current_integration
        request(endpoint, params: { app_id: app_id })
      end
    end
  end
end 