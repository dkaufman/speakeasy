class MessagesController < ApplicationController
  def index
    if room = Room.find_by_id(params[:room_id])
      @messages = room.messages
    else
      head status: :not_found
    end
  end

  def create
    if room = Room.find_by_id(params[:room_id])
      message = room.messages.build(params[:message])
      if message.save
        head status: :created, :location => [room, message]
      else
        head status: :bad_request
      end
    else
      head status: :not_found
    end
  end
end
