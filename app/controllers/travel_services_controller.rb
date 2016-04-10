class TravelServicesController < ApplicationController
  soap_service namespace: "urn:travel_ws", wsdl_style: "document"

  soap_action "add_new_constract",
    args: {add_new_constract_request: {
      tourID: :integer, customerIdNumber: :string,
      companyName: :string, companyPhone: :string,
      companyAddress: :string, bookingTickets: :integer}},
    return: {result: :string}

  def add_new_constract
    params = get_constract_params

    constract = Constract.new standarlize_params params
    messages = constract.save ? I18n.t("action.success") : constract.errors.full_messages
    render soap: {result: messages}
  end

  soap_action "check_available_tour",
    args: {check_available_tour_request: {tourCode: :string}},
    return: {result: :string}

  def check_available_tour
    if params[:check_available_tour_request] && params[:check_available_tour_request][:tourCode].present?
      tour = Tour.find_by code: params[:check_available_tour_request][:tourCode]
      render soap: {result: (tour.present? && tour.available_tickets > 0).to_s}
    else
      render soap: {result: I18n.t("errors.param_not_present", param: "tourCode")}
    end
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
