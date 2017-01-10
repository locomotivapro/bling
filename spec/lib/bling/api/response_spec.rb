require 'spec_helper'

describe Bling::API::Response do


  context 'with a valid http response' do
    let(:http_response) { Net::HTTPOK.new('1.1', '200', 'OK') }

    it 'is a success' do
      pending
      expect(described_class.new(http_response, 'foo').success?).to be_truthy
    end

  end

  context 'with a invalid http response' do
    let(:http_response) { Net::HTTPBadRequest.new('1.1', '400', 'Bad request') }

    it 'is a failure' do
      expect(described_class.new(http_response, 'foo').success?).to be_falsey
    end
  end
end
