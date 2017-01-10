require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'bling'

RSpec.configure do |config|
  config.color = true
end
