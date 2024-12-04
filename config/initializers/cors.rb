Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
      origins %r{https://[a-z0-9-]+\.ngrok-free\.app}
      resource "*", headers: :any, methods: [ :get, :post, :put, :delete, :options ]
  end
end
