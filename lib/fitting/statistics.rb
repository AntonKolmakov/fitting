require 'fitting/documentation/response/route'
require 'fitting/storage/responses'
require 'fitting/documentation/request/route'
require 'fitting/documentation/statistics'
require 'fitting/documentation/statistics_with_conformity_lists'

module Fitting
  class Statistics
    def initialize(response_routes, response_route_white)
      @response_routes = response_routes
      @response_route_white = response_route_white
    end

    def to_s
      res = ""
      if Fitting.configuration.white_list
        res += '[Black list]'
        response_route_black = Fitting::Documentation::Response::Route.new(
          Fitting::Storage::Responses.all,
          @response_routes.black
        )

        request_route = Fitting::Documentation::Request::Route.new(response_route_black)
        statistics = Fitting::Documentation::Statistics.new(request_route, @response_routes.black, response_route_black)
        res += "#{statistics}"

        res += '[White list]'
      end
      request_route = Fitting::Documentation::Request::Route.new(@response_route_white)
      statistics_with_conformity_lists = Fitting::Documentation::StatisticsWithConformityLists.new(request_route, @response_routes.white, @response_route_white)
      res += "#{statistics_with_conformity_lists}"
      res
    end
  end
end
