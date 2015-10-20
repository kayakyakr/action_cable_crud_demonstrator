EmberCLI.configure do |c|
  c.app :front, path: Rails.root.join('app', 'front'), exclude_ember_deps: "jquery"
end
