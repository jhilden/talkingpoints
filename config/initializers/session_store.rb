# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_talkingpoints_session',
  :secret      => 'f23cf6e79288dff42d0d97fa3a8a07ede2daf58e4da752b62c6326835af2d9b096fe9ba115aafb354ea2214bb84e56469fcf23f832a661246d691c90878d93a5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
