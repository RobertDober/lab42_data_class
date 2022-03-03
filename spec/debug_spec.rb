RSpec.describe Lab42::DataClass do
  context "Builtin Constraints" do
    # speculations/DATA_CLASSES.md:99
    require "lab42/data_class/builtin_constraints"
    let(:entry) { DataClass(:value).with_constraint(value: PairOf(Symbol, Anything)) }
    it "these constraints are well observed (speculations/DATA_CLASSES.md:105)" do
      expect(entry.new(value: Pair(:world, 42)).value).to eq(Pair(:world, 42))
      expect{ entry.new(value: Pair("world", 43)) }
        .to raise_error(Lab42::DataClass::ConstraintError)
      expect{ entry.new(value: Triple(:world, 43, nil)) }
        .to raise_error(Lab42::DataClass::ConstraintError)
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
