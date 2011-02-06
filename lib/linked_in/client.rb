module LinkedIn
  class Client
    include ToXmlHelpers
    include RequestHelpers
    include AuthorizationHelpers

    attr_reader :ctoken, :csecret, :consumer_options

    def initialize(ctoken=LinkedIn.token, csecret=LinkedIn.secret, options={})
      opts = {
        :request_token_path => "/uas/oauth/requestToken",
        :access_token_path  => "/uas/oauth/accessToken",
        :authorize_path     => "/uas/oauth/authorize"
      }
      @ctoken, @csecret, @consumer_options = ctoken, csecret, opts.merge(options)
    end


    def profile(options={})
      path   = person_path(options)
      fields = options[:fields] || LinkedIn.default_profile_fields

      if options[:public]
        path +=":public"
      elsif fields
        path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
      end

      Profile.from_xml(get(path))
    end

    def connections(options={})
      path = "#{person_path(options)}/connections"
      fields = options[:fields] || LinkedIn.default_profile_fields

      if options[:public]
        path +=":public"
      elsif fields
        path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
      end

      Connections.from_xml(get(path)).profiles
    end

    def search(options={})
      path = "/people"
      options = { :keywords => options } if options.is_a?(String)
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

    def share(options={})
      path = "/people/~/shares"
      defaults = { :visability => 'anyone' }
      post(path, share_to_xml(defaults.merge(options)))
    end

    def update_comment(network_key, comment)
      path = "/people/~/network/updates/key=#{network_key}/update-comments"
      post(path, comment_to_xml(comment))
    end

    def update_network(message)
      path = "/people/~/person-activities"
      post(path, network_update_to_xml(message))
    end

    def clear_status
      path = "/people/~/current-status"
      delete(path).code
    end

    def send_message(subject, body, recipient_paths)
      path = "/people/~/mailbox"

      message         = LinkedIn::Message.new
      message.subject = subject
      message.body    = body
      recipients      = LinkedIn::Recipients.new

      recipients.recipients = recipient_paths.map do |profile_path|
        recipient             = LinkedIn::Recipient.new
        recipient.person      = LinkedIn::Person.new
        recipient.person.path = "/people/#{profile_path}"
        recipient
      end

      message.recipients = recipients
      post(path, message_to_xml(message)).code
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

      def format_options_for_query(opts)
        opts.keys.each do |key|
          value = opts.delete(key)
          value = value.join("+") if value.is_a?(Array)
          value = value.gsub(" ", "+") if value.is_a?(String)
          opts[key.to_s.gsub("_","-")] = value
        end
        opts
      end

      def person_path(options)
        path = "/people/"
        if options[:id]
          path += "id=#{options[:id]}"
        elsif options[:url]
          path += "url=#{CGI.escape(options[:url])}"
        else
          path += "~"
        end
      end

  end
end
