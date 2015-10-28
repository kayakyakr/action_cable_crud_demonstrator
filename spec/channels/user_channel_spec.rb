require 'rails_helper'

RSpec.describe UserChannel, type: :cable do
  connect_to_cable
  let(:channel) { connection.send(:subscriptions).add "identifier" => "{\"channel\":\"UserChannel\"}" }

  describe "#list" do
    context "normal user" do
      let(:user){ create :user }
      it "adds streams for the current user" do
        expect{
          channel.list
        }.to change{ channel.send(:streams).length }.by 1
      end

      it "transmits user" do
        expect(channel).to receive(:transmit).with(ActiveModel::SerializableResource.new([user]).serializable_hash)
        channel.list
      end
    end

    context "with admin" do
      let(:user){ create :user, role: :admin }
      let!(:other_user) { create :user }

      it "adds streams for all users" do
        expect{
          channel.list
        }.to change{channel.send(:streams).length}.by(3)
      end

      it "transmits all users" do
        expect(channel).to receive(:transmit).with(ActiveModel::SerializableResource.new([user, other_user]).serializable_hash)
        channel.list
      end
    end
  end

  describe "#update" do
    let(:user){ create :user }

    it "updates user" do
      channel.update({"id" => user.id, "name" => 'MY NEW NAME IS YOU'})
      expect(user.reload.name).to eq 'MY NEW NAME IS YOU'
    end

    it "broadcasts update" do
      user.name = 'MY NEW NAME IS YOU'
      expect(UserChannel).to receive(:broadcast_to).with(user, ActiveModel::SerializableResource.new(user).serializable_hash)
      channel.update({"id" => user.id, "name" => 'MY NEW NAME IS YOU'})
    end
  end
end
