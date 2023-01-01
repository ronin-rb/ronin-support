RSpec::Matchers.define :fully_match do |expected|
  match do |actual|
    expect(actual.match(expected)[0]).to eq(actual)
  end

  description do
    "to fully match #{expected.inspect}"
  end
end
