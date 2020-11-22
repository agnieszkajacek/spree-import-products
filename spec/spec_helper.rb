# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'spree_dev_tools/rspec/spec_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].sort.each { |f| require f }
# Configure simeplecov for test coverage report
require 'simplecov'
SimpleCov.start do
  add_filter '/config/'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Overrides', 'app/overrides'
  add_group 'Libraries', 'lib'
  add_group 'Specs', 'spec'
end

# Requires factories and other useful helpers defined in spree_core.
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'

# Requires factories defined in lib/spree_braintree_vzero/factories.rb
require 'spree_import_products/factories'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # == URL Helpers
  #
  # Allows access to Spree's routes in specs:
  #
  # visit spree.admin_path
  # current_path.should eql(spree.products_path)
  config.include Spree::TestingSupport::UrlHelpers

  # == Requests support
  #
  # Adds convenient methods to request Spree's controllers
  # spree_get :index
  config.include Spree::TestingSupport::ControllerRequests, type: :controller

  # == Mock Framework

  config.mock_with :rspec
  config.color = true

  root_path = File.expand_path File.dirname(__FILE__)
  config.fixture_path = "#{root_path}/fixtures"
end