# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_quest_buster_session',
  :secret      => 'd29a25a05180ae7e093ecefbd11125bbdc6defad7787369c929d5b883d2f1bd9f2b07a67b09944d9b7a489946dfe1885edb6cbda5126a32315eb52957c675cb6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
