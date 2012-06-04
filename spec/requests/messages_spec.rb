require 'spec_helper'

describe "Messages" do
  let!(:room) { FactoryGirl.create(:room_with_messages) }
  let!(:url) { "/messages" }
  describe "get /messages" do
    context "messages viewable by this room" do
      let!(:empty_room) { FactoryGirl.create(:room) }
      context "the request has a valid room id in the header" do
        context "the room has messages" do
          before(:each) { get "#{url}.json", nil, {'room_id' => room.id} }
          it "returns a json with the room's messages" do
            messages_json = room.messages.to_json(only: :body)
            response.body.should == messages_json
          end
          it "returns a 200 response" do
            response.status.should == 200
          end
        end
        context "the room has no messages" do
          before(:each) { get "#{url}.json", nil, {'room_id' => empty_room.id} }
          it "returns an empty json" do
            response.body.should == "[]"
          end
          it "returns a 200 response" do
            response.status.should == 200
          end
        end
      end
      context "the request has a non-existent room id in the header" do
        before(:each) { get "#{url}.json", nil, {'room_id' => 99} }
        it "returns an invalid room response" do
          response.body.should == "Invalid Room"
        end
        it "returns a 400 response" do
          response.status.should == 400
        end
      end
      context "the request has no room id in the header" do
        before(:each) { get "#{url}.json" }
        it "returns a 400 response" do
        response.status.should == 400
        end
      end
    end
  end

  describe "post /messages" do
    let!(:message_count) { Message.count }
    context "with valid request body" do
      before(:each) do
        post "#{url}.json", body: {
          body: "Boom",
          room_id: room.id
        }
      end
      it "creates the message" do
        Message.last.body.should == "Boom"
        Message.count.should == message_count + 1
      end
      it "returns a 201 response" do
        response.status.should == 201
      end
    end
    context "without room id" do
      before(:each) do
        post "#{url}.json", body: {
          body: "Boom",
        }
      end
      it "does not create a room" do
        Message.count.should == message_count
      end
      it "returns a 400 response" do
        response.status.should == 400
      end
    end
    context "without message body" do
      before(:each) do
        post "#{url}.json", body: {
          room_id: room.id
        }
      end
      it "does not create a room" do
        Message.count.should == message_count
      end
      it "returns a 400 response" do
        response.status.should == 400
      end
    end
  end
end
