class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def create
    room = Room.new(JSON.parse(request.body.read))
    if room.save
      render status: :created, json: "Room Created"
    else
      render status: :bad_request, json: "Bad Request"
    end
  end

  def update
    room = Room.where(id: params["id"]).first
    if room
      if room.update_attributes(JSON.parse(request.body.read))
        render status: :ok, json: "Room Updated"
      else
        render status: :bad_request, json: "Bad Request"
      end
    else
      render status: :bad_request, json: "Bad Request"
    end
  end
  
  def destroy
    room = Room.where(id: params["id"]).first
    if room
      room.destroy
      render status: :ok, json: "Room Destroyed"
    else
      render status: :bad_request, json: "Bad Request"
    end
  end
end
