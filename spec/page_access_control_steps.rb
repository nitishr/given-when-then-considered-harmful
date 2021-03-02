# frozen_string_literal: true

require 'access_controlled_site'

module PageAccessControlSteps
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  step 'I am an :role user' do |role|
    case role
    when 'anonymous'
    when 'unauthorized' then basic_authorize('unauthorized', 'user')
    when 'authorized' then basic_authorize('authorized', 'user')
    end
  end

  step 'I go to the :opened page' do |opened|
    get page_path(opened)
    follow_redirect! if last_response.redirect?
  end

  step 'I should be on the :landed_on page' do |landed_on|
    expect(last_request.path_info).to eq page_path(landed_on)
  end

  def page_path(page)
    { 'public' => '/public', 'private' => '/private', 'login' => '/login' }[page]
  end
end
