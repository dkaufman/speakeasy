require 'spec_helper'

describe "Messages" do
  let(:room) { FactoryGirl.create(:room_with_messages) }

  describe "#index" do
    before(:each) { get room_messages_url(room, :format => :json) }

    context "the request has a valid room id in the body" do
      context "the room has messages" do
        it "returns a json with the room's messages" do
          messages_json = room.messages.to_json(only: :body)
          response.body.should == messages_json
        end

        it "returns a 200 response" do
          response.status.should == 200
        end
      end

      context "the room has no messages" do
        let(:room) { FactoryGirl.create(:empty_room) }

        it "returns an empty json" do
          response.body.should == "[]"
        end

        it "returns a 200 response" do
          response.status.should == 200
        end
      end
    end

    context "the request has a non-existent room id in the header" do
      let(:room) { double(:to_param => 9999) }

      it "returns a 404 response" do
        response.status.should == 404
      end
    end
  end

  describe "#create" do
    let!(:message_count) { Message.count }
    let(:room)    { FactoryGirl.create(:empty_room) }
    before(:each) { post room_messages_path(room, :format => :json), params }

    context "with valid request body" do
      let(:params) { {:message => {body: "Boom"}} }

      it "creates the message" do
        Message.last.body.should == "Boom"
        Message.count.should == message_count + 1
      end

      it "returns a 201 response" do
        response.status.should == 201
      end
    end

    context "without message body" do
      let(:params) { {} }
      it "does not create a message" do
        Message.count.should == message_count
      end
      it "returns a 400 response" do
        response.status.should == 400
      end
    end

    context "with a non-existent room" do
      let(:room)   { double(:to_param => 999) }
      let(:params) { {body: "Boom"} }

      it "does not create a message" do
        Message.count.should == message_count
      end
      it "returns a 404 response" do
        response.status.should == 404
      end
    end
  end
end
