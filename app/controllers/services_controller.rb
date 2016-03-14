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
end
