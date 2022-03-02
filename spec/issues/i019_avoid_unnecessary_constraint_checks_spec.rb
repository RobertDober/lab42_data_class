RSpec.describe Lab42::DataClass do
  let(:data_class) { DataClass(a: 1, b: 1).with_constraint(a: :positive?, b: :positive?) }
  let(:instance) { data_class.new }

  it "cannot become 0" do
    expect { instance.merge(a: 0) }.to raise_error(Lab42::DataClass::ConstraintError)
  end

  it "does not check for unchanged attributes" do
    expect { instance.merge(a: 2) }.not_to raise_error
  end
end
# SPDX-License-Identifier: Apache-2.0
