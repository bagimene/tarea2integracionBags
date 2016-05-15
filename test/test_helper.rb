#require 'coveralls'
#Coveralls.wear!('rails')

=begin
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'app/secrets'
end

if ENV["TRAVIS"]
  require "simplecov"
  require "coveralls"

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    # No need to report coverage metrics for the test code
    add_filter "test"
  end

  # Eager load the entire lib directory so that SimpleCov is able to report
  # accurate code coverage metrics.
  chandler_lib = File.expand_path("../../../lib", __FILE__)
  at_exit { Dir["#{chandler_lib}/**/*.rb"].each { |rb| require(rb) } }
end
=end
require 'coveralls'
Coveralls.wear!('rails')
#require 'simplecov'
#SimpleCov.start 'rails'


ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'



class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
