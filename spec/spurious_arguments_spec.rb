RSpec.describe "spurious arguments" do
  let(:data_class) { DataClass(a: 1) }
  it "its constructor will raise ArgumentError if called with a spurious argument" do
    expect{ data_class.new(b: 1) }.to raise_error(ArgumentError)
  end
end
#  SPDX-License-Identifier: Apache-2.0
