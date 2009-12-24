module LinkedIn
  class Client
    
    attr_reader :ctoken, :csecret, :consumer_options
    
    def initialize(ctoken=LinkedIn.token, csecret=LinkedIn.secret, options={})
      opts = { 
              :request_token_path => "/uas/oauth/requestToken",
              :access_token_path  => "/uas/oauth/accessToken",
              :authorize_path     => "/uas/oauth/authorize"
            }
      @ctoken, @csecret, @consumer_options = ctoken, csecret, opts.merge(options)
    end
    
    def consumer
      @consumer ||= ::OAuth::Consumer.new(@ctoken, @csecret, {:site => 'https://api.linkedin.com'}.merge(consumer_options))
    end
    
    def set_callback_url(url)
      clear_request_token
      request_token(:oauth_callback => url)
    end
    
    # Note: If using oauth with a web app, be sure to provide :oauth_callback.
    # Options:
    #   :oauth_callback => String, url that LinkedIn should redirect to
    def request_token(options={})
      @request_token ||= consumer.get_request_token(options)
    end
    
    # For web apps use params[:oauth_verifier], for desktop apps,
    # use the verifier is the pin that LinkedIn gives users.
    def authorize_from_request(rtoken, rsecret, verifier_or_pin)
      request_token = ::OAuth::RequestToken.new(consumer, rtoken, rsecret)
      access_token = request_token.get_access_token(:oauth_verifier => verifier_or_pin)
      @atoken, @asecret = access_token.token, access_token.secret
    end
    
    def access_token
      @access_token ||= ::OAuth::AccessToken.new(consumer, @atoken, @asecret)
    end
    
    def authorize_from_access(atoken, asecret)
      @atoken, @asecret = atoken, asecret
    end
    
    def get(path, options={})
      path = "/v1#{path}"
      response = access_token.get(path, options)
      raise_errors(response)
      response.body
    end
    
    def put(path, options={})
      path = "/v1#{path}"
      response = access_token.put(path, options)
      raise_errors(response)
      response
    end
    
    def delete(path, options={})
      path = "/v1#{path}"
      response = access_token.delete(path, options)
      raise_errors(response)
      response
    end
    
    
    def profile(options={})
      
      path = person_path(options)
      
      unless options[:fields].nil?
        if options[:public] 
          path +=":public"
        else
          path +=":(#{options[:fields].map{|f| f.to_s.gsub("_","-")}.join(',')})"
        end
      end
      
      Profile.from_xml(get(path))
    end
    
    def connections(options={})
      path = "#{person_path(options)}/connections"
      
      unless options[:fields].nil?
        if options[:public] 
          path +=":public"
        else
          path +=":(#{options[:fields].map{|f| f.to_s.gsub("_","-")}.join(',')})"
        end
      end
      
      Connections.from_xml(get(path)).profiles
    end
    
    def search(options={})
      path = "/people"
      options = {:keywords => options} if options.is_a?(String)
      options = format_options_for_query(options)
      
      People.from_xml(get(to_uri(path, options)))
    end
    
    def current_status
      path = "/people/~/current-status"
      Crack::XML.parse(get(path))['current_status']
    end
    
    def update_status(text)
      path = "/people/~/current-status"
      put(path, status_to_xml(text))
    end
    
    def clear_status
      path = "/people/~/current-status"
      delete(path).code
    end
    
    def network_statuses(options={})
      options[:type] = 'STAT'
      network_updates(options)
    end
    
    def network_updates(options={})
      path = "/people/~/network"
      Network.from_xml(get(to_uri(path, options)))
    end
    
    
    
    
    # helpful in making authenticated calls and writing the 
    # raw xml to a fixture file
    def write_fixture(path, filename)
      file = File.new("test/fixtures/#{filename}", "w")
      file.puts(access_token.get(path).body)
      file.close
    end
    
    private
      def clear_request_token
        @request_token = nil
      end
      
      def raise_errors(response)
        # Even if the XML answer contains the HTTP status code, LinkedIn also sets this code
        # in the HTTP answer (thankfully).
        case response.code.to_i
          when 400
            data = LinkedIn::Error.from_xml(response.body)
            raise RateLimitExceeded.new(data), "(#{response.code}): #{response.message} - #{data.code if data}"
          when 401
            data = LinkedIn::Error.from_xml(response.body)
            raise Unauthorized.new(data), "(#{response.code}): #{response.message} - #{data.code if data}"
          when 403
            data = LinkedIn::Error.from_xml(response.body)
            raise General.new(data), "(#{response.code}): #{response.message} - #{data.code if data}"
          when 404
            raise NotFound, "(#{response.code}): #{response.message}"
          when 500
            raise InformLinkedIn, "LinkedIn had an internal error. Please let them know in the forum. (#{response.code}): #{response.message}"
          when 502..503
            raise Unavailable, "(#{response.code}): #{response.message}"
        end
      end
      
      def format_options_for_query(opts)
        opts.keys.each do |key|
          value = opts.delete(key)
          value = value.join("+") if value.is_a?(Array)
          value = value.gsub(" ", "+") if value.is_a?(String)
          opts[key.to_s.gsub("_","-")] = value
        end
        opts
      end
      
      def to_query(options)
        options.inject([]) do |collection, opt|
          collection << "#{opt[0]}=#{opt[1]}"
          collection
        end * '&'
      end
      
      def to_uri(path, options)
        uri = URI.parse(path)

        if options && options != {}
          uri.query = to_query(options)
        end
        uri.to_s
      end
      
      def person_path(options)
        path = "/people/"
        if options[:id]
          path += "id=#{options[:id]}"
        elsif options[:email]
          path += "email=#{options[:email]}"
        elsif options[:url]
          path += "url=#{CGI.escape(options[:url])}"
        else
          path += "~"
        end
      end

      def status_to_xml(status)
        %Q{<?xml version="1.0" encoding="UTF-8"?>
        <current-status>#{status}</current-status>}
      end

    
  end
end