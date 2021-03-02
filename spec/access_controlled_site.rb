# frozen_string_literal: true

require 'rack/auth/basic'
require 'sinatra'

get '/public' do
  if_auth_provided { |auth_| 'public page' }
end

get '/private' do
  if_auth_provided { |auth| auth.username == 'authorized' ? 'private page' : redirect('/public') }
end

get '/login' do
  'login form'
end

private

def if_auth_provided
  auth = Rack::Auth::Basic::Request.new(env)
  if auth.provided?
    yield auth
  else
    redirect('login')
  end
end
