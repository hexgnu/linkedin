require 'linked_in/helpers/request'
require 'linked_in/helpers/authorization'
require 'linked_in/api/query_methods'
require 'linked_in/api/update_methods'

require 'cgi'

module LinkedIn

  class Client
    include Helpers::Request
    include Helpers::Authorization
    include Api::QueryMethods
    include Api::UpdateMethods

    attr_reader :ctoken, :csecret, :consumer_options

    def initialize(ctoken=LinkedIn.token, csecret=LinkedIn.secret, options={})
      opts = {
        :request_token_path => "/uas/oauth/requestToken",
        :access_token_path  => "/uas/oauth/accessToken",
        :authorize_path     => "/uas/oauth/authorize"
      }
      @ctoken, @csecret, @consumer_options = ctoken, csecret, opts.merge(options)
    end

    # def search(options={})
    #   path = "/people"
    #   options = { :keywords => options } if options.is_a?(String)
    #   options = format_options_for_query(options)
    #
    #   People.from_xml(get(to_uri(path, options)))
    # end
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

    private

      # def format_options_for_query(opts)
      #   opts.keys.each do |key|
      #     value = opts.delete(key)
      #     value = value.join("+") if value.is_a?(Array)
      #     value = value.gsub(" ", "+") if value.is_a?(String)
      #     opts[key.to_s.gsub("_","-")] = value
      #   end
      #   opts
      # end
  end

end
