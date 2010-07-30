module LinkedIn
  class Group  < LinkedIn::Base

    def groups
      @array ||= begin
        @array = []
        @doc.children.each do |group|
          @array << Resource.new(group) unless group.blank?
        end
        @array
      end
    end

    class Resource

      def initialize(group)
        @group = group
      end

      def id
        @group.xpath('//member-group/id').text.to_i
      end

      def name
        @group.xpath('//member-group/name').text
      end

      def url
        @group.xpath('//member-group/site-group-request/url').text
      end

    end # resource class

  end
end
