module LinkedIn
  module Helpers

    module Authorization

      DEFAULT_OAUTH_OPTIONS = {
        :request_token_path => "/uas/oauth/requestToken",
        :access_token_path  => "/uas/oauth/accessToken",
        :authorize_path     => "/uas/oauth/authorize",
        :api_host           => "https://api.linkedin.com",
        :auth_host          => "https://www.linkedin.com"
      }

      def consumer
        @consumer ||= ::OAuth::Consumer.new(@consumer_token, @consumer_secret, parse_oauth_options)
      end

      # Note: If using oauth with a web app, be sure to provide :oauth_callback.
      # Options:
      #   :oauth_callback => String, url that LinkedIn should redirect to
      def request_token(options={})
        @request_token ||= consumer.get_request_token(options)
      end

      # For web apps use params[:oauth_verifier], for desktop apps,
      # use the verifier is the pin that LinkedIn gives users.
      def authorize_from_request(request_token, request_secret, verifier_or_pin)
        request_token = ::OAuth::RequestToken.new(consumer, request_token, request_secret)
        access_token  = request_token.get_access_token(:oauth_verifier => verifier_or_pin)
        @auth_token, @auth_secret = access_token.token, access_token.secret
      end

      def access_token
        @access_token ||= ::OAuth::AccessToken.new(consumer, @auth_token, @auth_secret)
      end

      def authorize_from_access(atoken, asecret)
        @auth_token, @auth_secret = atoken, asecret
      end

      private

        # since LinkedIn uses api.linkedin.com for request and access token exchanges,
        # but www.linkedin.com for authorize/authenticate, we have to take care
        # of the url creation ourselves.
        def parse_oauth_options
          {
            :request_token_url => full_oauth_url_for(:request_token, :api_host),
            :access_token_url  => full_oauth_url_for(:access_token,  :api_host),
            :authorize_url     => full_oauth_url_for(:authorize,     :auth_host),
            :site              => @consumer_options[:site] || @consumer_options[:api_host] || DEFAULT_OAUTH_OPTIONS[:api_host]
          }
        end

        def full_oauth_url_for(url_type, host_type)
          if @consumer_options["#{url_type}_url".to_sym]
            @consumer_options["#{url_type}_url".to_sym]
          else
            host = @consumer_options[:site] || @consumer_options[host_type] || DEFAULT_OAUTH_OPTIONS[host_type]
            path = @consumer_options[:"#{url_type}_path".to_sym] || DEFAULT_OAUTH_OPTIONS["#{url_type}_path".to_sym]
            "#{host}#{path}"
          end
        end

    end

  end
end
