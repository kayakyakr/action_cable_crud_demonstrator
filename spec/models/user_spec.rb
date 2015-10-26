require 'rails_helper'

RSpec.describe User, type: :model do
  context '#broadcast_create' do
    it "fires broadcast on create" do
      user = build :user, id: 1
      expect(ActionCable.server).to receive(:broadcast).with("new_user",
        {id: 1, email: user.email, name: user.name, role: 'user', version: 0}).once
      user.save
    end
  end

  context "#broadcast" do
    let(:user) { create :user }
    it "fires broadcast on update" do
      expect(UserChannel).to receive(:broadcast_to).with(user,
        {id: user.id, email: user.email, name: "HAHA I BROKE YOUR NAME", role: 'user', version: 1}).once
      user.update name: "HAHA I BROKE YOUR NAME", version: 1
    end
  end
end
