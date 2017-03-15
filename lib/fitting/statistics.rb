require 'fitting/documentation/response/monochrome_route/route'
require 'fitting/storage/responses'
require 'fitting/documentation/request/route'
require 'fitting/documentation/statistics'
require 'fitting/documentation/statistics_with_conformity_lists'

module Fitting
  class Statistics
    def initialize(response)
      request_route_black = Fitting::Documentation::Request::Route.new(response.monochrome_route.black)
      request_route_white = Fitting::Documentation::Request::Route.new(response.monochrome_route.white)
      @statistics = Fitting::Documentation::Statistics.new(request_route_black, response.routes.black, response.monochrome_route.black)
      @statistics_with_conformity_lists = Fitting::Documentation::StatisticsWithConformityLists.new(request_route_white, response)
    end

    def to_s
      if Fitting.configuration.white_list
        str_statistics = [
          ['[Black list]', @statistics].join("\n"),
          '[White list]'
        ].join("\n\n")
      end

      [str_statistics, @statistics_with_conformity_lists, "\n"].compact.join("\n")
    end
  end
end
