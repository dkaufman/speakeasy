require 'spec_helper'

describe "/messages", :type => :api do
  context "messages viewable by this room" do
    let!(:message) { Message.new(:body => "Wrench", :room_id => 1) }
    let!(:url) { "/messages" }

    it "json" do
      get "#{url}.json"

      messages_json = Message.all.to_json
      last_response.body.should eql(messages_json)
    end
  end
end
