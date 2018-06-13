#require 'simplecov'
#SimpleCov.start

require 'rspec'
require 'rspec/expectations'
require_relative '../lib/glmath'

 RSpec.configure do |config|
   config.expect_with(:rspec) do |c|
     c.syntax = :expect
   end
 end

include GLMath