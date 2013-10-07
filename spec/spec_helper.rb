specdir=File.dirname(__FILE__)

load File.join(File.expand_path( '../../lib/tasks/vcloud_walk.thor', __FILE__))

require 'rspec'
require 'rspec/mocks'
require_relative 'stubs/stubs'
require_relative 'stubs/service_layer_stub'
require_relative 'integration/data'

def set_login_credential username = 'some-username', password = 'some-password'
  ENV['API_USERNAME'] = username
  ENV['API_PASSWORD'] = password
end



