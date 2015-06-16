require_relative '../lib/mathgl'
require 'rspec'
require 'rspec/expectations'

RSpec.configure do |config|
  config.expect_with(:rspec) do |c|
    c.syntax = [:should, :expect]
  end
end

include MathGL