require 'spec_helper'

describe LookCommand do
  context "syntax" do
    it { expect(command_parse_results("look")).to eq(parse_to(LookCommand)) }
  end

  context "when there is a player logged in" do
    let(:room) { Room.new(name: 'Starting Room') }
    let(:player) { Player.new.tap { |p| p.location = room } }
    let(:server) { stub_carbonmu_server }

    context "#execute" do
      it "prints the name of the current room" do
        allow_any_instance_of(LookCommand).to receive(:notify_location_description)
        allow_any_instance_of(LookCommand).to receive(:notify_contents)
        expect(server).to receive(:notify_player).with(
          player,
          "location.name",
          { message: "Starting Room" }
        )
        run_command_with_player(LookCommand, player)
      end

      it "prints the description of the current room" do
        allow_any_instance_of(LookCommand).to receive(:notify_location_name)
        allow_any_instance_of(LookCommand).to receive(:notify_contents)
        expect(server).to receive(:notify_player).once.ordered.with(
            player,
            "location.description",
            { message: "You see nothing special." }
        )
        run_command_with_player(LookCommand, player)
      end
    
      it "prints the contents of the room if there is contents" do
        Thing.new(name: "1 angry dragon").location = room
        allow_any_instance_of(LookCommand).to receive(:notify_location_name)
        allow_any_instance_of(LookCommand).to receive(:notify_location_description)
        expect(server).to receive(:notify_player).once.ordered.with(
            player,
            "location.contents",
            { message: "1 angry dragon" }
        )
        run_command_with_player(LookCommand, player)

      end
    end
  end
end
