require 'rails_helper'

RSpec.describe AccountsChannel, type: :cable do
  connect_to_cable
  let(:channel) { connection.send(:subscriptions).add "identifier" => "{\"channel\":\"AccountsChannel\"}" }

  describe "#list" do
    context "normal user" do
      let(:user){ create :user }
      let!(:account) { create :account, user: user }
      it "adds streams for the current user" do
        expect{
          channel.list
        }.to change{ channel.send(:streams).length }.by 1
      end

      it "transmits user" do
        expect(channel).to receive(:transmit).with(ActiveModel::SerializableResource.new([account]).serializable_hash)
        channel.list
      end
    end

    context "with admin" do
      let(:user){ create :user, role: :admin }
      let!(:other_user) { create :user }
      let!(:account) { create :account, user: other_user }

      it "adds streams for all users" do
        expect{
          channel.list
        }.to change{channel.send(:streams).length}.by(2)
      end

      it "transmits all users" do
        expect(channel).to receive(:transmit).with(ActiveModel::SerializableResource.new([account]).serializable_hash)
        channel.list
      end
    end
  end

  describe "#create" do
  end

  describe "#update" do
  end

  describe "#destroy" do
  end
end
