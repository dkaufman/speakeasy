class MessagesController < ApplicationController
  def index
    room = Room.where(id: request.headers["room_id"]).first
    if room
      @messages = room.messages
    end
    render status: :bad_request, json: "Invalid Room" unless @messages
  end

  def create
    message = Message.create(body: params["body"]["body"], room_id: params["body"]["room_id"])
    if message.save
      render status: :created, json: "Message Created"
    else
      render status: :bad_request, json: "Bad Request"
    end
  end
end
