module LinkedIn

  module AuthorizationHelpers

    def consumer
      @consumer ||= begin
        options = { :site => 'https://api.linkedin.com' }.merge(@consumer_options)
        ::OAuth::Consumer.new(@ctoken, @csecret, options)
      end
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

    private

      def clear_request_token
        @request_token = nil
      end

  end

end