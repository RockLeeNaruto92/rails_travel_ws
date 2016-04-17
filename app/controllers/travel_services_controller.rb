class TravelServicesController < ApplicationController
  soap_service namespace: "urn:travel_ws", wsdl_style: "document"

  soap_action "check_available_tour",
    args: {check_available_tour_request: {tourId: :integer, bookingTickets: :integer}},
    return: {result: :integer}

  def check_available_tour
    tour_params = params[:check_available_tour_request] || {}
    tour_params["tourId"] ||= 0
    tour_params["bookingTickets"] ||= 1
    condition = "id = #{tour_params["tourId"]} and available_tickets > #{tour_params["bookingTickets"]}"
    tours = Tour.where condition
    render soap: {result: tours.empty? ? 0 : 1}
  end
end
