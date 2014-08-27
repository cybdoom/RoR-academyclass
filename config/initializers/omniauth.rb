Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :facebook, '104497059901', '57692b980f0cc1b4ac78e6706c79de35', :callback_url => "http://www.academyclass.com/auth/facebook/callback"
    provider :twitter, 'SR1sEhJf4VPNTAK8b5zXfw', 'v7jvr3bwcHYgDXmB8mFlkbVvA1HbTpx4nsB3DbKog'
  else
    provider :twitter, 'huiNW2P1WBQQXXg8q2YMw', '5UYfj2QTkqEOerCvQe9RzhMPe4E5Sb6wcqooEL7WnQ'
    provider :facebook, '104497059901', '57692b980f0cc1b4ac78e6706c79de35'
  end
end