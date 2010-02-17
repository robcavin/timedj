# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_TimeDJ_session',
  :secret      => '2018e4b2a6e5df168092aed038324edc304d28f448d9df612996def75cfcc80ae7c40ca0a662e8fd1a36ddf1568a0125ea0b83720c1786c6ee800894aac80f27'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
