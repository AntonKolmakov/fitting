require 'tomograph'

module Fitting
  module Storage
    class WhiteList
      def initialize(white_list, resource_white_list, resources)
        @white_list = white_list
        @resource_white_list = resource_white_list
        @resources = resources
        @warnings = []
      end

      def to_a
        return @white_list if @white_list
        @white_list = transformation
      end

      def without_group
        return @without_group_list if @without_group_list
        @without_group_list = @resource_white_list.inject([]) do |all_requests, resource|
          resource_selection(resource, all_requests)
        end.flatten.uniq
        puts_warnings
        @without_group_list
      end

      def resource_selection(resource, all_requests)
        if resource[1] == []
          find_warnings(resource[0])
          requests(@resources[resource[0]], all_requests)
        else
          requests(resource[1], all_requests)
        end
      end

      def find_warnings(resource)
        return nil if @resources[resource]
        @warnings.push(
          "FITTING WARNING: In the documentation there isn't resource from the resource_white_list #{resource}"
        )
      end

      def puts_warnings
        return nil if @warnings == []
        warnings_string = @warnings.join("\n")
        puts "\n#{warnings_string}"
      end

      def requests(resource, all_requests)
        return all_requests unless resource

        resource.map do |request|
          all_requests.push(request_hash(request))
        end
        all_requests
      end

      def transformation
        result = without_group.group_by { |action| action[:path] }
        result.inject({}) do |res, group|
          methods = group.last.map { |gr| gr[:method] }
          res.merge(group.first => methods)
        end
      end

      def request_hash(request)
        array = request.split(' ')
        {
          method: array[0],
          path: Tomograph::Path.new(array[1]).to_s
        }
      end
    end
  end
end
