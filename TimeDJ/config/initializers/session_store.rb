# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_TimeDJ_session',
  :secret      => '55d63fccb46bcefa42cc331507739b110c9649c1715e771aa9f73ca914324dccf887098ada0c1e791d798b501b222c0eae38c2990bb3abd854882e0a1b71dbee'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
