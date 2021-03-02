# frozen_string_literal: true

require 'access_controlled_site'
require 'rack/test'

RSpec.describe 'users are routed to pages by role' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  specify 'anonymous users are routed to the login page' do
    as_anonymous_user do
      opening(public_page, takes_you_to: login_page)
      opening(private_page, takes_you_to: login_page)
    end
  end

  specify 'unauthorized users are routed to the public page' do
    as_unauthorized_user do
      opening(public_page, takes_you_to: public_page)
      opening(private_page, takes_you_to: public_page)
    end
  end

  specify 'authorized users are routed to the opened page' do
    as_authorized_user do
      opening(public_page, takes_you_to: public_page)
      opening(private_page, takes_you_to: private_page)
    end
  end

  def opening(path, takes_you_to:)
    get path
    follow_redirect! if last_response.redirect?
    expect(last_request.path_info).to eq(takes_you_to)
  end

  def public_page
    '/public'
  end

  def private_page
    '/private'
  end

  def login_page
    '/login'
  end

  def as_anonymous_user
    yield
  end

  def as_unauthorized_user
    basic_authorize('unauthorized', 'user')
    yield
  end

  def as_authorized_user
    basic_authorize('authorized', 'user')
    yield
  end
end
