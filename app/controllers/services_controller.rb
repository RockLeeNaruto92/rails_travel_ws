class ServicesController < ApplicationController
  soap_service namespace: "urn:travel_ws"

  soap_action "add_new_place",
    args: {code: :string, name: :string, city: :string, country: :string,
      address: :string, services: :string, description: :string},
    return: :string

  def add_new_place
    place = Place.new params
    messages = place.save ? "Successfully!" : place.errors.full_messages
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
    args: {code: :string, place: :string, sdate: :date,
      tickets: :integer, cost: :integer, description: :string},
    return: :string

  def add_new_tour
    standarlize_tour_params
    tour = Tour.new params
    messages = tour.save ? "Successfully!" : tour.errors.full_messages
    render soap: messages
  end

  soap_action "is_existed_tour",
    args: {code: :string},
    return: :boolean

  def is_existed_tour
    tour = Tour.find_by code: params[:code]
    render soap: tour.present?
  end

  private
  def standarlize_tour_params
    params[:place_code] = params[:place]
    params[:start_date] = params[:sdate]
    params.delete :place
    params.delete :sdate
  end
end
