require 'spec_helper'

describe Bling::API::Client do
  before(:each) { allow(Net::HTTP).to receive(:get_response) }
  let(:client) { Bling::API::Client.new('path', {}, :product) }

  it 'always return a Response object' do
    expect(client.get).to be_kind_of(Bling::API::Response)
  end

  it 'always set api key' do
    expect(Bling.config).to receive(:api_key)
    client.get
  end

  it 'get default response format' do
    expect(Bling.config).to receive(:response_format)
    client.get
  end

  it 'get default api endpoint' do
    expect(Bling.config).to receive(:api_url).and_return('https://foo.bar')
    client.get
  end

  describe '#get' do
    it 'set parameter to uri' do
      expect( URI ).to receive(:encode_www_form)
      client.get
    end

    it 'makes a get request' do
      expect(Net::HTTP).to receive(:get_response)
      client.get
    end
  end

  describe '#post' do
    it 'makes a post request' do
      expect(Net::HTTP).to receive(:post_form)
      client.post
    end
  end

end
