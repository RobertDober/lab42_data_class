RSpec.describe Lab42::Nil do
  it "can cons" do
    expect(Nil.cons(:a)).to eq(Lab42::List.cons(:a, Nil))
  end
end

# SPDX-License-Identifier: Apache-2.0
