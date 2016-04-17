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

  soap_action "add_new_constract",
    args: {add_new_constract_request: {
      tourId: :integer, customerIdNumber: :string,
      companyName: :string, companyPhone: :string,
      companyAddress: :string, bookingTickets: :integer}},
    return: {result: :integer}

  def add_new_constract
    params = get_constract_params

    constract = Constract.new standarlize_params params
    messages = constract.save ? constract.id : -1
    render soap: {result: messages}
  end

  private
  def standarlize_params params
    params.keys.each do |key|
      unless key.to_s == key.to_s.underscore
        params[key.to_s.underscore.to_sym] = params[key]
        params.delete key
      end
    end
    params
  end

  def get_constract_params
    params[:add_new_constract_request]
  end
end
