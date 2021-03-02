# frozen_string_literal: true

require 'access_controlled_site'
require 'rack/test'

RSpec.describe 'users are routed to pages by role' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  specify 'anonymous users are routed to the login page' do
    opening(public_page, as: anonymous_user, takes_you_to: login_page)
    opening(private_page, as: anonymous_user, takes_you_to: login_page)
  end

  specify 'unauthorized users are routed to the public page' do
    opening(public_page, as: unauthorized_user, takes_you_to: public_page)
    opening(private_page, as: unauthorized_user, takes_you_to: public_page)
  end

  specify 'authorized users are routed to the opened page' do
    opening(public_page, as: authorized_user, takes_you_to: public_page)
    opening(private_page, as: authorized_user, takes_you_to: private_page)
  end

  def opening(path, as:, takes_you_to:)
    basic_authorize(*as) if as.is_a?(Array)
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

  def anonymous_user
    nil
  end

  def unauthorized_user
    %w[unauthorized user]
  end

  def authorized_user
    %w[authorized user]
  end
end
