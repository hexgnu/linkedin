
# TODO
# `consumer` renamed to `client`
#
# rename OAuth to OAuth2
#
# deprecate `request_token`
# deprecate `access_token`
#
# deprecate `authorize_from_request`
# deprecate `authorize_from_access`
#
# cleanup bottom
# deprecate `oauth_callback`
#
# DONE 
# `consumer_token renamed to `client_id`
# `consumer_secret renamed to `client_secret`
# request_token_url is deprecated. Replaced with token_url
# access_token_url is deprecated. Replaced with token_url
# request_token_path is deprecated
# access_token_path has changed
# authorize_path has been deprecated

module LinkedIn
  module Helpers

    module Authorization

      DEFAULT_OAUTH2_OPTIONS = {
        authorize_path: "/uas/oauth2/authorization",
        access_token_path: "/uas/oauth2/accessToken",
        api_host: "https://api.linkedin.com",
        auth_host: "https://www.linkedin.com"
      }

      def oauth2_client
        @oauth2_client ||= ::OAuth2::Client.new(@client_id,
                                                @client_secret,
                                                parse_oauth2_options)
      end

      # A way to fetch the authorize_url
      # @param :redirect_uri - Where you want it to redirect to after
      # @param :scope - A list of member permissions you would like to
      # request.
      def authorize_url(params={})
        # response_type param included by default by using the OAuth 2.0
        # auth_code strategy
        # client_id param included automatically by the OAuth 2.0 gem
        params[:state] ||= state
        params[:redirect_uri] ||= "http://localhost"
        oauth2_client.auth_code.authorize_url(params)
      rescue OAuth2::Error => e
        raise LinkedIn::Errors::UnauthorizedError.new(e.code), e.description
      end

      # Fetches the access_token given the auth_code fetched by
      # navigating to `authorize_url`
      # @param :redirect_uri - Where you want to redirect after you have
      # fetched the token.
      def request_access_token(code, params={})
        params[:redirect_uri] ||= "http://localhost"
        opts = {}
        opts[:mode] = :query
        opts[:param_name] = "oauth2_access_token"
        @access_token = oauth2_client.auth_code.get_token(code, params, opts)
      rescue OAuth2::Error => e
        raise LinkedIn::Errors::UnauthorizedError.new(e.code), e.description
      end

      # If one already has an access_token string, it can be set here and
      # turned into an OAuth2::AccessToken object.
      def set_access_token(token, options={})
        options[:access_token] = token
        options[:mode] = :query
        options[:param_name] = "oauth2_access_token"
        @access_token = OAuth2::AccessToken.from_hash oauth2_client, options
      end

      # NOTE: There is an attr_reader for :access_token.

      private

        # The keys of this hash are designed to match the OAuth2
        # initialize spec.
        def parse_oauth2_options
          default = {site: DEFAULT_OAUTH2_OPTIONS[:api_host],
                     token_url: full_oauth_url_for(:access_token, :auth_host),
                     authorize_url: full_oauth_url_for(:authorize, :auth_host)}
          return default.merge(@client_options)
        end

        def full_oauth_url_for(url_type, host_type)
          host = DEFAULT_OAUTH2_OPTIONS[host_type]
          path = DEFAULT_OAUTH2_OPTIONS["#{url_type}_path".to_sym]
          "#{host}#{path}"
        end

        def state
          o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
          @state ||= (0...50).map{ o[rand(o.length)] }.join
        end
    end
  end
end
