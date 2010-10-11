module LinkedIn
  class TwitterAccounts < LinkedIn::Base

    def accounts
      @arry ||= begin
        @arry = []
        @doc.children.each do |twitter_account|
          @arry << TwitterAccount.new(twitter_account) unless twitter_account.blank?
        end
        @arry
      end
    end

    class TwitterAccount

      def initialize(twitter_account)
        @twitter_account = twitter_account
      end

      def account_id
        @twitter_account.xpath("./provider-account-id").text
      end

      def account_name
        @twitter_account.xpath("./provider-account-name").text
      end

    end

  end
end
