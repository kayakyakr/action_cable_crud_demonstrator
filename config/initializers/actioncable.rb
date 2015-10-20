ActionCable.server.config.worker_pool_size = Integer(ENV["CABLE_POOL_SIZE"] || 10)
ActionCable.server.config.allowed_request_origins = ENV["DOMAINS"].split unless ENV["DOMAINS"].blank?
