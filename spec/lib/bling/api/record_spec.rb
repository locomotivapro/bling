require 'spec_helper'

describe Bling::API::Record do

  it 'create readers to each hash key' do
    params = { name: 'Bilbo', age: 111 }
    hobbit = Bling::API::Record.new(params)
    expect(hobbit.name).to eq 'Bilbo'
    expect(hobbit.age).to eq 111
  end

end
