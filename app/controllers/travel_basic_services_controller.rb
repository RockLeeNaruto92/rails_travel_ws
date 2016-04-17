class TravelBasicServicesController < ApplicationController
  soap_service namespace: "urn:travel_ws"

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
      messages = if tour.present?
        place_params = {place_id: tour.place_id, place_name: tour.place.name}
        tour.attributes.merge(place_params)
      else
        {}
      end.to_json
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
          model: "tour", attr: "code", value: params[:code]).to_json
      end
      render soap: messages
    else
      render soap: I18n.t("errors.param_not_present", param: "code")
    end
  end

  soap_action "get_place_by_id",
    args: {id: :integer},
    return: :string

  def get_place_by_id
    if params[:id].present?
      place = Place.find_by id: params[:id]
      messages = if place.present?
        place.attributes.merge(tour_codes: place.tours.pluck(:code))
      else
        {}
      end.to_json
      render soap: messages
    else
      render soap: I18n.t("errors.param_not_present", param: "id")
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
end
