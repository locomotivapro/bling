require "codeclimate-test-reporter"
require 'byebug'
CodeClimate::TestReporter.start

require 'bling'

RSpec.configure do |config|
  config.color = true
end
