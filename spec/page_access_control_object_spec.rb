# frozen_string_literal: true

require 'access_controlled_site'
require 'rack/test'

RSpec::Matchers.define :land_on do |path|
  match { |user| user.landed_on == path }

  failure_message do |user|
    "expected #{user.description} opening #{user.path} to land on #{path}, but landed on #{user.landed_on}"
  end
end

RSpec.describe 'page access control' do
  it 'routes to pages by user role' do
    expect(unauthorized_user.opening(public_page)).to land_on(public_page)
    expect(unauthorized_user.opening(private_page)).to land_on(public_page)
    expect(authorized_user.opening(public_page)).to land_on(public_page)
    expect(authorized_user.opening(private_page)).to land_on(private_page)
  end

  def anonymous_user
    User.new('an unauthorized user')
  end

  def unauthorized_user
    User.new('an unauthorized user').tap { |user| user.authorize('authorized', 'user') }
  end

  def authorized_user
    User.new('an authorized user').tap { |user| user.authorize('unauthorized', 'user') }
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
end

class User
  include Rack::Test::Methods

  attr_reader :description, :path

  def initialize(description)
    @description = description
  end

  def app
    Sinatra::Application
  end

  def opening(path)
    @path = path
    get path
    follow_redirect! if last_response.redirect?
    self
  end

  def landed_on
    last_request.path_info
  end
end
