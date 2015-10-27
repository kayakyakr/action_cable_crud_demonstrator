require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :cable do
  setup_connection

  describe "#connect" do
    context "has user" do
      login_user

      it "sets user on connect" do
        expect(connection.current_user).to eq(nil)
        connection.connect
        expect(connection.current_user).to eq(user)
      end
    end

    it "errors when no user is logged in" do
      expect{
        connection.connect
      }.to raise_error ActionCable::Connection::Authorization::UnauthorizedError
    end
  end
end
