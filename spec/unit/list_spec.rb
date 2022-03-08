RSpec.describe Lab42::List do
  let(:my_list) { List(*1..3) }
  it "can cdddr" do
    expect(my_list.cdddr).to eq(Nil)
  end
end
# SPDX-License-Identifier: Apache-2.0
