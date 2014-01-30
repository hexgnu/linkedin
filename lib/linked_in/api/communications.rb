module LinkedIn
  module Api

    # Communications APIs
    #
    # @see http://developer.linkedin.com/documents/communications
    module Communications

      # (Create) send a message from the authenticated user to a
      # connection
      #
      # Permissions: w_messages
      #
      # @see http://developer.linkedin.com/documents/messaging-between-connections-api
      # @see http://developer.linkedin.com/documents/invitation-api Invitation API
      #
      # @example
      #   client.send_message("subject", "body", ["person_1_id", "person_2_id"])
      #
      # @param [String] subject Subject of the message
      # @param [String] body Body of the message, plain text only
      # @param [Array<String>] recipient_paths a collection of
      #  profile paths that identify the users who will receive the
      #  message
      # @return [void]
      def send_message(subject, body, recipient_paths)
        path = "/people/~/mailbox"

        message = {
            'subject' => subject,
            'body' => body,
            'recipients' => {
                'values' => recipient_paths.map do |profile_path|
                  { 'person' => { '_path' => "/people/#{profile_path}" } }
                end
            }
        }
        post(path, MultiJson.dump(message), "Content-Type" => "application/json")
      end

    end

  end
end
