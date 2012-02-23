module OauthActiveResource
  class Base < ActiveResource::Base
    
    @@oauth_connection = nil
    
    def self.oauth_connection= connection
      @@oauth_connection = connection
    end
        
    def self.oauth_connection
      @@oauth_connection
    end
    
    def self.connection(refresh = false)
      @connection = Connection.new(@@oauth_connection, site,format) if @connection.nil? || refresh
      @connection.timeout = timeout if timeout
      return @connection
    end
    
    def format=(mime_type_reference_or_format)
      format = mime_type_reference_or_format.is_a?(Symbol) ?
      OauthActiveResource::Formats[mime_type_reference_or_format] : mime_type_reference_or_format
      self._format = format
      connection.format = format if site
    end
    
  end
  
  class Connection < ActiveResource::Connection
    def initialize(oauth_connection, *args)
      @oauth_connection = oauth_connection
      super(*args)
    end
    
  private
    def request(method, path, *arguments)
      if @oauth_connection == nil
        super(method, path, *arguments)
      else
        path = "#{site.scheme}://#{site.host}:#{site.port}#{path}"
        response = @oauth_connection.send(method, path, *arguments)
        handle_response(response)
      end
    rescue Timeout::Error => e
      raise TimeoutError.new(e.message)
    end
  end
end