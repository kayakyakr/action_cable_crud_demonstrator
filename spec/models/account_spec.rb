require 'rails_helper'

RSpec.describe Account, type: :model do
  context '#broadcast' do
    let(:user) { create :user }
    let(:account) { create :account, user: user }
    it "fires broadcast on create" do
      account = build :account, user: user, id: 1
      expect(ActionCable.server).to receive(:broadcast).with("user_#{user.id}_account",
        {id: account.id, name: account.name, user_id: user.id, :destroyed? => false, version: 0}).once
      account.save
    end

    it "fires broadcast on update" do
      expect(ActionCable.server).to receive(:broadcast).with("user_#{user.id}_account",
        {id: account.id, name: "HAHA I BROKE YOUR ACCOUNT NAME", user_id: user.id, :destroyed? => false, version: 1}).once
      account.update name: "HAHA I BROKE YOUR ACCOUNT NAME", version: 1
    end

    it "fires broadcast on destroy" do
      expect(ActionCable.server).to receive(:broadcast).with("user_#{user.id}_account",
        {id: account.id, name: account.name, user_id: user.id, :destroyed? => true, version: 0}).once
      account.destroy
    end
  end
end
