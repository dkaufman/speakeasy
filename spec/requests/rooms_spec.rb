require 'spec_helper'

describe "Rooms" do
  describe "get /rooms" do
    let!(:room) { FactoryGirl.create(:room) }
    let!(:url) { "/rooms" }
    before(:each) { get "#{url}.json" }
    it "returns a successful json response of all rooms" do
      response.body.should include { room.name }
      response.body.should include { room.description }
      response.status.should == 200
    end
  end

  describe "post /rooms" do
    let!(:url) { "/rooms" }
    let!(:room_count) { Room.count }
    before(:each) { post "#{url}.json", params.to_json }
    context "with a complete, valid request body" do
      let!(:params) { {name: "Hungry Academy", description: "Boom"} }
      it "creates a room with a 201 response" do
        Room.last.name.should == "Hungry Academy"
        Room.last.description.should == "Boom"
        Room.count.should == room_count + 1
        response.status.should == 201
      end
    end
    context "with a partial, valid request body" do
      let!(:params) { {name: "Hungry Academy", } }
      it "creates a room with a 201 response" do
        Room.last.name.should == "Hungry Academy"
        Room.last.description.should be_nil
        Room.count.should == room_count + 1
        response.status.should == 201
      end
    end
    context "without a valid request body" do
      let!(:params) { {} }
      it "does not create a room" do
        Room.count.should == room_count
        response.status.should == 400
      end
    end
  end

  describe "put /rooms/:id" do
    let!(:url) { "/rooms/#{room_id}" }
    let!(:room) { FactoryGirl.create(:room) }
    before(:each) { put "#{url}.json", params.to_json }
    context "with an existing room id" do
      let!(:room_id) { room.id }
      context "with full valid request body" do
        let!(:params) { {name: "Hungry", description: "Academy"} }
        it "should update the room information" do
          Room.find(room_id).name.should == "Hungry"
          Room.find(room_id).description.should == "Academy"
          response.status.should == 200
        end
      end
      context "with a partial valid request body" do
        let!(:params) { {name: "Hungry"} }
        it "should update only the provided room information" do
          Room.find(room_id).name.should == "Hungry"
          Room.find(room_id).description.should_not be_nil
          response.status.should == 200
        end
      end
      context "with an invalid request body" do
        let!(:params) { {name: ""} }
        it "should not update the room information" do
          Room.find(room_id).name.should_not == "Hungry"
          response.status.should == 400
        end
      end
    end
    context "with a non-existent room id" do
      let!(:room_id) { 9999}
      let!(:params) { {name: "Hungry"} }
      it "returns a 400 error" do
        response.status.should == 400
      end
    end
  end

  describe "delete /rooms/:id" do
    let!(:url) { "/rooms/#{room_id}" }
    let!(:room) { FactoryGirl.create(:room) }
    before(:each) { delete "#{url}.json" }
    context "with an existing room id" do
      let!(:room_id) { room.id }
      it "destroys the room" do
        Room.find_by_id(room.id).should be_nil
        response.status.should == 200
      end
    end
    context "with a non-existent room id" do
      let!(:room_id) { 9999 }
      it "returns a 400 error" do
        response.status.should == 400
      end
    end
  end
end
