require 'cgi'

module LinkedIn

  class Client
    include Helpers::Request
    include Helpers::Authorization
    include Helpers::V2Request
    include Api::QueryHelpers
    include Api::People
    include Api::Groups
    include Api::Companies
    include Api::Jobs
    include Api::ShareAndSocialStream
    include Api::Communications
    include Api::V2
    include Search

    attr_reader :consumer_token, :consumer_secret, :consumer_options

    def initialize(ctoken=LinkedIn.token, csecret=LinkedIn.secret, options={})
      @consumer_token   = ctoken
      @consumer_secret  = csecret
      @consumer_options = options
    end

    #
    # def current_status
    #   path = "/people/~/current-status"
    #   Crack::XML.parse(get(path))['current_status']
    # end
    #
    # def network_statuses(options={})
    #   options[:type] = 'STAT'
    #   network_updates(options)
    # end
    #
    # def network_updates(options={})
    #   path = "/people/~/network"
    #   Network.from_xml(get(to_uri(path, options)))
    # end
    #
    # # helpful in making authenticated calls and writing the
    # # raw xml to a fixture file
    # def write_fixture(path, filename)
    #   file = File.new("test/fixtures/#{filename}", "w")
    #   file.puts(access_token.get(path).body)
    #   file.close
    # end

  end

end
