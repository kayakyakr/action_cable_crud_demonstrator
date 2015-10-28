module CableMacros
  def setup_connection
    let(:env) { { "rack.session" => {} } }
    let(:request) { ActionDispatch::Request.new(env) }
    let(:connection) { ApplicationCable::Connection.new ActionCable.server, env }

    before(:each) do
      connection.instance_variable_set(:@request, request)
      websocket = double('websocket')
      allow(websocket).to receive(:transmit)
      connection.instance_variable_set(:@websocket, websocket)
      env['warden'] = begin
        manager = Warden::Manager.new(nil) do |config|
          config.merge! Devise.warden_config
        end
        Warden::Proxy.new(env, manager)
      end
    end
  end

  def login_user
    before(:each) do
      env['warden'].instance_variable_get(:@users).delete(:user)
      env['warden'].session_serializer.store(user, :user)
    end
  end

  def connect_to_cable
    setup_connection
    login_user
    before(:each) { connection.connect }
  end
end
