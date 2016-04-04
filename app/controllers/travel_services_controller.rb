class TravelServicesController < ApplicationController
  soap_service namespace: "urn:travel_ws", wsdl_style: "document"

  soap_action "add_new_place",
    args: {code: :string, name: :string, city: :string, country: :string,
      address: :string, services: :string, description: :string},
    return: :string

  def add_new_place
    place = Place.new params
    messages = place.save ? I18n.t("action.success") : place.errors.full_messages
    render soap: messages
  end

  soap_action "is_existed_place",
    args: {code: :string, name: :string},
    return: :boolean

  def is_existed_place
    place = Place.find_by code: params[:code] if params[:code].present?
    if !place.present? && params[:name].present?
      place = Place.find_by name: params[:name] unless place.present?
    end
    render soap: place.present?
  end

  soap_action "add_new_tour",
    args: {code: :string, placeID: :integer, startDate: :date,
      tickets: :integer, cost: :integer, description: :string},
    return: :string

  def add_new_tour
    standarlize_params
    tour = Tour.new params
    messages = tour.save ? I18n.t("action.success") : tour.errors.full_messages
    render soap: messages
  end

  soap_action "is_existed_tour",
    args: {code: :string},
    return: :boolean

  def is_existed_tour
    tour = Tour.find_by code: params[:code]
    render soap: tour.present?
  end

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

  soap_action "find_tours_by_city",
    args: {cityName: :string},
    return: :string

  def find_tours_by_city
    if params[:cityName].present?
      render soap: Tour.where(place: Place.where(city: params[:cityName])).to_json
    else
      render soap: I18n.t("errors.param_not_present", param: "cityName")
    end
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

  soap_action "update_tour_information",
    args: {code: :string, placeID: :integer, startDate: :date,
      tickets: :integer, cost: :integer, description: :string},
    return: :string

  def update_tour_information
    standarlize_params
    tour = Tour.find_by code: params[:code]
    if tour.present?
      messages = tour.update_attributes(params) ? I18n.t("action.success") : tour.errors.full_messages
      render soap: messages
    else
      render soap: I18n.t("errors.object_not_exist",
        model: "tour", attr: "code", value: params[:code])
    end
  end

  soap_action "get_all_places",
    return: :string

  def get_all_places
    render soap: Place.all.to_json
  end

  soap_action "get_all_tours",
    return: :string

  def get_all_tours
    render soap: Tour.all.to_json
  end

  soap_action "find_tour_by_code",
    args: {code: :string},
    return: :string

  def find_tour_by_code
    if params[:code].present?
      tour = Tour.find_by code: params[:code]
      messages = tour.present? ? tour.to_json : I18n.t("errors.object_not_exist",
        model: "tour", attr: "code", value: params[:code])
      render soap: messages
    else
      render soap: I18n.t("errors.param_not_present", param: "code")
    end
  end

  soap_action "delete_tour_by_code",
    args: {code: :string},
    return: :string

  def delete_tour_by_code
    if params[:code].present?
      tour = Tour.find_by code: params[:code]
      messages = if tour.present?
        tour.destroy
        tour.destroyed? ? I18n.t("action.success") : I18n.t("errors.deletion",
          model: "tour", attr: "code", value: params[:code])
      else
        I18n.t("errors.object_not_exist",
          model: "tour", attr: "code", value: params[:code])
      end
      render soap: messages
    else
      render soap: I18n.t("errors.param_not_present", param: "code")
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
