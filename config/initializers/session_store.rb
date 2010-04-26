# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_loan_arranger_session',
  :secret      => '0494eae8c17d37addc0201043b5e10fc2dc73d431266eaba4926a3a3972e311ee5a91fb20b2cf428f9eb7a4ebf4721f4837481041340a1a6ce7bf83556852950'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
